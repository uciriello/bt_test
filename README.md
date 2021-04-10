# mobile_app

A new Flutter project.

## Table of Contents

1. [Getting Started](#1-getting-started)
2. [Themes](#2-themes)
3. [Routes](#3-routes)
4. [Providers](#4-providers)
5. [Internationalization](#5-internationalization)
6. [GraphQL](#6-graphql)
7. [Push Notifications](#7-notifications)
8. [OpenApi](#8-openapi)


## 1. Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 2. Themes
To change the general appearance of the app change the file in **lib/configutations/themes.dart**

## 3. Routes
In every screen define the static route variable and initialize it, then register the rout 
in **lib/configutations/routes.dart**

## 4. Providers
To manage the global changing and the data retrieved define a provider file 
in lib/provider and register a new provider in **lib/configutations/app_providers.dart**

## 5. Internationalization
Translation are provided by **lib/providers/global_translation**

Define the new internationalized strings **assets/locale/lang.json**

To use translatable text import **/providers/global_translation.dart** and use translations.text(text)

## 6. GraphQL

To manage GraphQL use client class in **lib/graph_ql**. This class is configured to accept url and bearerToken and creates a graphQL client based on [graphql_flutter](https://pub.dev/packages/graphql_flutter)

In order to use GraphQL responses go into your widget and wrap your scaffold into *GraphQLProvider* class and set client to the new instance of graphQL class.

To improve your code also wrap up *GraphQLProvider* into *FutureBuilder<ValueNotifier<GraphQLClient>>* and then use *getGraphQLClient()* to get client in async way.

## 7. Push Notifications

To manage Push Notifications have a look at **lib/notifications**, based on [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)

There are 2 files:

- **LocalNotifications**: implements platform-based notification in a flutter's way
- **FCMNotification**: implements Firebase notification and use *LocalNotification* to show it in android devices
	
Ensure also configuration in **main.dart** as below:


```
	_initNotifications() async {

		new FCMNotification();

		await LocalNotifications.instance.initPlugin();

	}
```

To test push notification execute this command:

```
	DATA='{"notification": {"body": "This is a body", "title": "This is a title"}, "priority": "high", "to": "TOKEN_OF_APP"}'
	curl https://fcm.googleapis.com/fcm/send -H "Content-Type:application/json" -X POST -d "$DATA" -H "Authorization: key=FIREBASE_CLOUD_MESSAGE_KEY"
```

## 8. OpenApi

In order to use open api generator have a look at [openapi_generator](https://pub.dev/packages/openapi_generator), configure as description said and run:

```
	flutter pub run build_runner build --delete-conflicting-outputs
```
	
And add this project to *pubspect.yaml* (rickandmorty_api is *pubName* in openapi configuration):

```
  rickandmorty_api:
    path: ./openapi/
```

Then it'all, we just created a file to handle all api feature in **lib/api/request_center.dart**


