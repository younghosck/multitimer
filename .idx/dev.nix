# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.flutter
    pkgs.jdk17
  ];

  # Sets environment variables in the workspace
  env = {
    FLUTTER_ROOT = "${pkgs.flutter}";
  };

  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];

    # Enable previews and emulators
    previews = {
      enable = true;
      previews = {
        # Android emulator preview
        android = {
          command = ["flutter" "run" "--machine" "-d" "android" "-d" "emulator-5554"];
          manager = "flutter";
        };
        # Web preview for Flutter
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
      };
    };

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        # Install Flutter dependencies
        flutter-pub-get = "flutter pub get";
      };
      
      # Runs when the workspace is (re)started
      onStart = {
        # Enable web and Android support
        flutter-config = "flutter config --enable-web --no-analytics && flutter config --android-sdk $ANDROID_HOME";
      };
    };
  };
}

