{ pkgs }:
let
  background = /home/asrifox/Pictures/wallpapers/kawakami_rokkaku_holo_snowyspring0.jpeg;
  themeConf = pkgs.writeText "theme.conf" ''
    [General]
    Background="background.png"
    DimBackgroundImage="0.0"
    ScaleImageCropped="true"
    ScreenWidth="2560"
    ScreenHeight="1440"

    FullBlur="true"
    PartialBlur="false"
    BlurRadius="80"

    HaveFormBackground="false"
    FormPosition="center"
    BackgroundImageHAlignment="center"
    BackgroundImageVAlignment="center"
    MainColor="#363a4f"
    AccentColor="#cad3f5"
    BackgroundColor="#24273a"
    placeholderColor="#bbbbbb"
    IconColor="#ffffff"
    OverrideLoginButtonTextColor=""
    InterfaceShadowSize="6"
    InterfaceShadowOpacity="0.6"
    RoundCorners="20"
    ScreenPadding="0"
    Font="FiraCode Nerd Font"
    FontSize=""

    HideLoginButton="false"
    ForceRightToLeft="false"
    ForceLastUser="true"
    ForcePasswordFocus="true"
    ForceHideCompletePassword="true"
    ForceHideVirtualKeyboardButton="true"
    ForceHideSystemButtons="false"
    AllowEmptyPassword="false"
    AllowBadUsernames="false"

    Locale=""
    HourFormat="HH:mm"
    DateFormat="dddd d MMMM"

    TranslatePlaceholderUsername=""
    TranslatePlaceholderPassword=""
    TranslateLogin=""
    TranslateLoginFailedWarning=""
    TranslateCapslockWarning=""
    TranslateSuspend=""
    TranslateHibernate=""
    TranslateReboot=""
    TranslateShutdown=""
    TranslateVirtualKeyboardButton=""
  '';
in pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "ae6b7a4ad8d14da1cc3c3b712f1241b75dcfe836";
    hash = "sha256-pYhHgDiuyckKV2y325sZ5tuqVYLtKaWofKqsY7kgEpQ=";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cp -f ${background} $out/background.png
    cp -f ${themeConf} $out/theme.conf
  '';
}

