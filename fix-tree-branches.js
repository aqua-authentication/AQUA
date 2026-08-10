var isNode = typeof process !== "undefined" && process.versions && process.versions.node;
var fs = isNode ? require("fs") : null;
var args = isNode ? process.argv.slice(2) : (function () {
  var values = [];
  for (var i = 0; i < WScript.Arguments.length; i++) values.push(WScript.Arguments.Item(i));
  return values;
})();

if (args.length === 0) {
  if (isNode) process.exit(1);
  WScript.Quit(1);
}

function escapeRegex(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function readUtf8(path) {
  if (isNode) return fs.readFileSync(path, "utf8");
  var stream = new ActiveXObject("ADODB.Stream");
  stream.Type = 2;
  stream.Charset = "utf-8";
  stream.Open();
  stream.LoadFromFile(path);
  var text = stream.ReadText();
  stream.Close();
  return text;
}

function writeUtf8(path, text) {
  if (isNode) {
    fs.writeFileSync(path, text, "utf8");
    return;
  }
  var stream = new ActiveXObject("ADODB.Stream");
  stream.Type = 2;
  stream.Charset = "utf-8";
  stream.Open();
  stream.WriteText(text);
  stream.SaveToFile(path, 2);
  stream.Close();
}

function boxFor(svg, title) {
  var pattern = new RegExp('<g id="node\\d+" class="node">\\s*<title>' + escapeRegex(title) + '<\\/title>\\s*<path[^>]* d="([^"]+)"', "m");
  var match = pattern.exec(svg);
  if (!match) throw new Error("Node not found: " + title);
  var values = match[1].match(/-?\d+(?:\.\d+)?/g);
  var minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
  for (var i = 0; i < values.length; i += 2) {
    var x = parseFloat(values[i]);
    var y = parseFloat(values[i + 1]);
    if (x < minX) minX = x;
    if (x > maxX) maxX = x;
    if (y < minY) minY = y;
    if (y > maxY) maxY = y;
  }
  return { left: minX, top: minY, right: maxX, bottom: maxY };
}

function rounded(value) {
  return Math.round(value * 100) / 100;
}

function parentNames(svg) {
  var pattern = /<title>([^<]+)&#45;&gt;([^<]+)<\/title>/g;
  var found = {};
  var names = [];
  var match;
  while ((match = pattern.exec(svg)) !== null) {
    if (match[1] !== "Root" && !found[match[1]]) {
      found[match[1]] = true;
      names.push(match[1]);
    }
  }
  return names;
}

function cleanParentBranch(svg, parentName) {
  var parent = boxFor(svg, parentName);
  var parentY = (parent.top + parent.bottom) / 2;
  var edgePattern = new RegExp('<title>' + escapeRegex(parentName) + '&#45;&gt;([^<]+)<\\/title>', "g");
  var children = [];
  var match;
  while ((match = edgePattern.exec(svg)) !== null) children.push(match[1]);
  if (children.length === 0) return svg;

  var childBoxes = [];
  var childLeft = Infinity;
  for (var i = 0; i < children.length; i++) {
    var childBox = boxFor(svg, children[i]);
    childBoxes.push(childBox);
    if (childBox.left < childLeft) childLeft = childBox.left;
  }

  var trunkX = parent.right + (childLeft - parent.right) * 0.48;
  for (var j = 0; j < children.length; j++) {
    var childY = (childBoxes[j].top + childBoxes[j].bottom) / 2;
    var pathData = "M" + rounded(parent.right) + "," + rounded(parentY) +
      " L" + rounded(trunkX) + "," + rounded(parentY) +
      " L" + rounded(trunkX) + "," + rounded(childY) +
      " L" + rounded(childBoxes[j].left) + "," + rounded(childY);
    var edge = new RegExp('(<title>' + escapeRegex(parentName) + '&#45;&gt;' + escapeRegex(children[j]) + '<\\/title>\\s*<path[^>]* d=")[^"]+("\\/>)', "m");
    svg = svg.replace(edge, "$1" + pathData + "$2");
  }
  return svg;
}

function cleanFile(path) {
  var svg = readUtf8(path);
  var parents = parentNames(svg);
  for (var i = 0; i < parents.length; i++) svg = cleanParentBranch(svg, parents[i]);
  writeUtf8(path, svg);
}

try {
  for (var i = 0; i < args.length; i++) cleanFile(args[i]);
} catch (error) {
  if (isNode) {
    console.error(error.message);
    process.exit(1);
  }
  WScript.Echo(error.message);
  WScript.Quit(1);
}
