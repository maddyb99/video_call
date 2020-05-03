# Video Call

An application to video call with all your friends at once. This app currently supports upto 14 users at a time

## Getting Started

Anyone with a little experience in Flutter can set this up and start developing easily.

**This setup will involve 4 basic steps:**

- Clone this repository:
    ```
    git clone <https://github.com/maddyb99/video_call> 
    ```

- **Add firebase** to this flutter project. Steps to do this can be found in this [official guide](https://firebase.google.com/docs/flutter/setup).

- Connect this to a **REST API** that manages user data. For this, find the API URL and Private Key and modify the following:

    1. Rename `lib/common/public` to `lib/common/private` (private folder will not be committed to git)
    2. Modify `lib/common/private/web_api_constants.dart` and add your API URL and Private Key to it.
       ```
        class WebApiInfo {
          static get baseUrl=>'YOUR-API-HOSING-URL';
          static get ver=>'YOUR-API-VERSION';
          static get apiKey=>'YOUR-API-KEY';
          static get apiUrl => "$baseUrl/$ver";
        }
        ```
    3. (OPTIONAL)Make other modifications to `lib/common/repository/user_repository.dart` and `lib/common/models/user.dart` in accordance with your API
    4. (ONLY IF STEP 3 WAS PERFORMED) Run:
        ```
        flutter packages pub run build_runner build
        ```

- Copy your **Agora Project App ID** and replace `YOUR-APP-ID` in `lib/common/private/agora_sdk_constants.dart` with the App ID
    ```
    class AgoraSdkInfo{
      static get appId=>'YOUR-APP-ID';
    }
    ```
    If you cannot find the private folder, refer step 1 of adding REST API Keys.
    If you are new to Agora, you can create a new project by following this [official guide](https://docs.agora.io/en/Agora%20Platform/manage_projects?platform=All%20Platforms).
