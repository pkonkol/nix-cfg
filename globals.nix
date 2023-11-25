let
  srcery = {
    # ansi
    black = "1C1B19";
    red = "EF2F27";
    green = "519F50";
    yellow = "FBB829";
    blue = "2C78BF";
    magenta = "E02C6D";
    cyan = "0AAEB3";
    white = "BAA67F";
    brightblack = "918175";
    brightred = "F75341";
    brightgreen = "98BC37";
    brightyellow = "FED06E";
    brightblue = "68A8E4";
    brightmagenta = "FF5C8F";
    brightcyan = "2BE4D0";
    brightwhite = "FCE8C3";
    # additional
    orange = "FF5F00";
    brightorange = "FF8700";
    hardblack = "121212";
    teal = "008080";
    xgray1 = "262626"; # 235, darkest
    xgray2 = "303030";
    xgray3 = "3A3A3A";
    xgray4 = "444444";
    xgray5 = "4E4E4E";
    xgray6 = "585858";
    xgray7 = "626262";
    xgray8 = "6C6C6C";
    xgray9 = "767676";
    xgray10 = "808080";
    xgray11 = "8A8A8A";
    xgray12 = "949494"; # 246, brightest
  };
in {
  test = "1234";

  font = "Terminus";

  colors =
    srcery
    // rec {
      base16 = {
        base00 = srcery.xgray2;
        base01 = srcery.xgray3;
        base02 = srcery.xgray4;
        base03 = srcery.xgray5;
        base04 = srcery.xgray6;
        base05 = srcery.xgray8;
        base06 = srcery.xgray10;
        base07 = srcery.xgray12;
        base08 = srcery.red;
        base09 = srcery.orange;
        base0A = srcery.yellow;
        base0B = srcery.green;
        base0C = srcery.cyan;
        base0D = srcery.blue;
        base0E = srcery.magenta;
        base0F = srcery.black;
      };

      base24 =
        base16
        // {
          base10 = srcery.xgray1;
          base11 = srcery.hardblack;
          base12 = srcery.brightred;
          base13 = srcery.brightyellow;
          base14 = srcery.brightgreen;
          base15 = srcery.brightcyan;
          base16 = srcery.brightblue;
          base17 = srcery.brightmagenta;
        };
    };

  defaultResolution = "1200x1300";
}
