objc-utils
==========

Some useful utilities in objc

## macros.h

## DownloadHelper
```objc
// download a single file
[DownloadHelper fetch:@"stores.db"];
[DownloadHelper fetch:@"stores1.db"];
[DownloadHelper fetch:@"stores2.db"];

// download mulitple files
[DownloadHelper fetchAll:@[@"stores.db",@"store1.db",@"stores2.db",@"stores3.db",@"stores4.db"] baseURL:API_URL complete:^{
  // Do whatever you need to do when all requests are finished
  NSLog(@"all requests are finished");
  [self initSqlite:@"stores.db"];
}];

```

## LayoutHelper
```objc
// add a label for title
CSLinearLayoutItem *titleItem = [CSLinearLayoutItem layoutItemForView:[LayoutHelper addTitleLabel:@"my left title"]];
titleItem.padding = CSLinearLayoutMakePadding(5.0, 10.0, 5.0, 10.0);
titleItem.horizontalAlignment = CSLinearLayoutItemHorizontalAlignmentLeft;
[_layoutView addItem:titleItem];

// add a image from SDImageCache
SDImageCache *cache = [SDImageCache sharedImageCache];
UIImage *resizeImage = [UIImage resizeImage:[cache imageFromDiskCacheForKey:[item.picUrl absoluteString]] convertToWidth:300];
CSLinearLayoutItem *imageItem = [CSLinearLayoutItem layoutItemForView:[LayoutHelper addImage:resizeImage]];
imageItem.padding = CSLinearLayoutMakePadding(5.0, 10.0, 5.0, 10.0);
imageItem.horizontalAlignment = CSLinearLayoutItemHorizontalAlignmentCenter;
[_layoutView addItem:imageItem];
```

## LogManager
Output log message to FLEX.

### Installation
```
pod "FLEX", git => 'https://github.com/wwwins/FLEX.git', :branch => 'custom'
pod "Realm"
```

### Usage
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[FLEXManager sharedManager] showExplorer];

  LogManager *logManager = [LogManager sharedManager];
  [logManager log:@"Start LogManager..."];
}
```

