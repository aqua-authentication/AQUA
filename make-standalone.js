var args = WScript.Arguments;
if (args.length !== 1) {
  WScript.Echo("Usage: cscript //nologo make-standalone.js <html-file>");
  WScript.Quit(1);
}

function readUtf8(path) {
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
  var stream = new ActiveXObject("ADODB.Stream");
  stream.Type = 2;
  stream.Charset = "utf-8";
  stream.Open();
  stream.WriteText(text);
  stream.SaveToFile(path, 2);
  stream.Close();
}

try {
  var path = args.Item(0);
  var html = readUtf8(path);

  html = html.replace(/<script\b[^>]*>[\s\S]*?<\/script>/gi, function (block) {
    return /id=["']quality-model-interactions["']/i.test(block) ? block : "";
  });


  writeUtf8(path, html);
  WScript.Echo("Created standalone HTML with one local interaction script.");
} catch (error) {
  WScript.Echo(error.message);
  WScript.Quit(1);
}
