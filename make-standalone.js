var isWSH = typeof WScript !== "undefined";

function echo(message) {
  if (isWSH) {
    WScript.Echo(message);
  } else {
    console.log(message);
  }
}

function quit(code) {
  if (isWSH) {
    WScript.Quit(code);
  } else {
    process.exit(code);
  }
}

function getArguments() {
  if (isWSH) {
    var result = [];
    var i;

    for (i = 0; i < WScript.Arguments.length; i++) {
      result.push(WScript.Arguments.Item(i));
    }

    return result;
  }

  return process.argv.slice(2);
}

function readUtf8(path) {
  if (isWSH) {
    var stream = new ActiveXObject("ADODB.Stream");

    stream.Type = 2;
    stream.Charset = "utf-8";
    stream.Open();
    stream.LoadFromFile(path);

    var text = stream.ReadText();

    stream.Close();
    return text;
  }

  return require("fs").readFileSync(path, "utf8");
}

function writeUtf8(path, text) {
  if (isWSH) {
    var stream = new ActiveXObject("ADODB.Stream");

    stream.Type = 2;
    stream.Charset = "utf-8";
    stream.Open();
    stream.WriteText(text);
    stream.SaveToFile(path, 2);
    stream.Close();

    return;
  }

  require("fs").writeFileSync(path, text, "utf8");
}

var args = getArguments();

if (args.length !== 1) {
  echo(
    isWSH
      ? "Usage: cscript //nologo make-standalone.js <html-file>"
      : "Usage: node make-standalone.js <html-file>"
  );

  quit(1);
}

try {
  var path = args[0];
  var html = readUtf8(path);

  html = html.replace(
    /<script\b[^>]*>[\s\S]*?<\/script>/gi,
    function (block) {
      return /id=["']quality-model-interactions["']/i.test(block)
        ? block
        : "";
    }
  );

  writeUtf8(path, html);

  echo("Created standalone HTML with one local interaction script.");
} catch (error) {
  echo(error.message);
  quit(1);
}