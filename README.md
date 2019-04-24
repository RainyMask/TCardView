# TCardView

[![CI Status](https://img.shields.io/travis/1370254410@qq.com/TCardView.svg?style=flat)](https://travis-ci.org/1370254410@qq.com/TCardView)
[![Version](https://img.shields.io/cocoapods/v/TCardView.svg?style=flat)](https://cocoapods.org/pods/TCardView)
[![License](https://img.shields.io/cocoapods/l/TCardView.svg?style=flat)](https://cocoapods.org/pods/TCardView)
[![Platform](https://img.shields.io/cocoapods/p/TCardView.svg?style=flat)](https://cocoapods.org/pods/TCardView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TCardView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TCardView'
```

## Usage
```
TCardView *cardView = [[TCardView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - 200)];
cardView.isOpenAutoScroll = NO;
cardView.isEditing = YES;
cardView.imageArr = @[@"pic0", @"pic1", @"pic2", @"pic3", @"pic4"];
[self.view addSubview:cardView];
```

## Screenshots
![demo1](https://raw.githubusercontent.com/RainyMask/TCardView/master/Example/TCardView/demo1.png)
![demo2](https://raw.githubusercontent.com/RainyMask/TCardView/master/Example/TCardView/demo2.png)

## Author

1370254410@qq.com, daitao@chaorey.com

## License

TCardView is available under the MIT license. See the LICENSE file for more info.
