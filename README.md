# MimeerApp
Public repository for the Mimeer iOS and macOS source code.

## Overview

This repository contains the public source code for the Mimeer iOS and macOS apps. While this does represent the production code deployed in the App Store some additional resources required to build the full application, such as the xcode project that consumes this package, must be kept secret for privacy reasons and are not hosted in this repository. The code you see here is imported by the host application and wraps the relevant package targets in Xcode targets. For example, the `MimeerWidgets` product from this package is consumed by the widget extension for the Mimeer app. Common code shared by the application and its extensions is hosted in the `MimeerKit` framework.

## Copyright

This code is copyright of Caleb Friden and provided solely for demonstration purposes.
