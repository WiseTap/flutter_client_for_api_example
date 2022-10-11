# flutter_client_for_api_example

A simple example of a Flutter App showing
how the client side would be interacting with the server side.

Check the server side by [clicking here](https://github.com/WiseTap/internal-api-example-firebase-nodejs).

1. [Testing: Different users performing HTTP requests to the API](#testing-different-users-performing-http-requests-to-the-api)
2. [Getting Started](#getting-started)
 
# Testing: Different users performing HTTP requests to the API

## First Store Owner (custom claim: `storeOwner`)
Will not get errors
![Alt Text](gifs/store-owner-1.gif)

## Buyer (custom claim: `buyer`)
Will get errors when trying to perform any Store Owner operations
![Alt Text](gifs/buyer.gif)

## Second Store Owner (custom claim: `storeOwner`)
Will get error when trying to perform a operation that only **First** Store Owner can do
![Alt Text](gifs/store-owner-2.gif)

# Getting Started

## Install Flutter
This project uses the Flutter framework, [install Flutter](https://docs.flutter.dev/get-started/install).
Run the project by using Android Studio (recommended).

## Configure Firebase in this App
Go to your Firebase project > Project Overview > **Add app** > **Flutter**
and follow the instructions.

## Replace the server URL with your IPv4
In this project, go to `lib/data/api.dart` and replace `192.168.0.31`
with the IPv4 on your local network where the server is running.