# Video Call

An application to video call with all your friends at once. This app currently supports upto 14 users at a time

## Getting Started

Anyone with a little experience in Flutter can set this up and start developing easily.

**This setup will involve 4 basic steps:**

1. Clone this repository:
    ```shell script
    git clone <https://github.com/maddyb99/video_call>
    cd video_call 
    flutter pub get 
    ```

2. **Add firebase** to this flutter project.

    To do this, you have to simply place your `google-services.json` file at `android/app/`.

    If this doesn't work or you are new to firebase, you can fin the complete steps in this [official guide](https://firebase.google.com/docs/flutter/setup).

3. Connect this to a **REST API** that manages user data. For this,
    find the API URL and Private Key and modify the following:

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
    3. *(IF-REQUIRED)* Make other modifications to `lib/common/repository/user_repository.dart` and `lib/common/models/user.dart` in accordance with your API and then run:
        ```
        flutter packages pub run build_runner build
        ```
    If you do not intend to make your own API or use a custom one, you can quickly find and deploy the model [User Management API](https://github.com/maddyb99/user_management_api) being used in this project.
4. Copy your **Agora Project App ID** and replace `YOUR-APP-ID` in
   `lib/common/private/agora_sdk_constants.dart` with the App ID
    ```
    class AgoraSdkInfo{
    static get appId=>'YOUR-APP-ID';
    }
    ```
    If you cannot find the private folder, refer step 3(i)

    If you are new to Agora, you can create a new project by following this
    [official guide](https://docs.agora.io/en/Agora%20Platform/manage_projects?platform=All%20Platforms).
