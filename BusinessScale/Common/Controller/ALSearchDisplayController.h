//
//  ALSearchDisplayController.h
//  BusinessScale
//
//  Created by Alvin on 16/2/23.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALSearchDisplayController : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *searchResultsTableView;

@property (strong, nonatomic) NSMutableArray *resultsSource;

// 编辑cell时显示的风格，默认为UITableViewCellEditingStyleDelete；会将值付给[tableView:editingStyleForRowAtIndexPath:]
@property (nonatomic) UITableViewCellEditingStyle editingStyle;

@property (nonatomic,copy) UITableViewCell * (^cellForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic,copy) BOOL (^canEditRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic,copy) CGFloat (^heightForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic,copy) void (^didSelectRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic,copy) void (^didDeselectRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);

@end
