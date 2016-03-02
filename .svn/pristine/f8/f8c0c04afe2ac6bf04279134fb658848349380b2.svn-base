//
//  ALSearchDisplayController.m
//  BusinessScale
//
//  Created by Alvin on 16/2/23.
//  Copyright © 2016年 Alvin. All rights reserved.
//
#import "ALSearchDisplayController.h"

@interface ALSearchDisplayController()



@end

@implementation ALSearchDisplayController

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _resultsSource = [NSMutableArray array];
        _searchResultsTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _searchResultsTableView.dataSource = self;
        _searchResultsTableView.delegate = self;
        [self addSubview:_searchResultsTableView];
    }
    return self;
}

//- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController
//{
//    self = [super initWithSearchBar:searchBar contentsController:viewController];
//    if (self) {
//        // Custom initialization
//        _resultsSource = [NSMutableArray array];
////        _editingStyle = UITableViewCellEditingStyleDelete;
//        
//        self.searchResultsDataSource = self;
//        self.searchResultsDelegate = self;
//        self.searchResultsTitle = @"搜索结果";
//    }
//    return self;
//}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultsSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellForRowAtIndexPathCompletion) {
        return _cellForRowAtIndexPathCompletion(tableView, indexPath);
    }
    else{
        static NSString *CellIdentifier = @"ContactListCell";
        BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_canEditRowAtIndexPath) {
        return _canEditRowAtIndexPath(tableView, indexPath);
    }
    else{
        return NO;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_heightForRowAtIndexPathCompletion) {
        return _heightForRowAtIndexPathCompletion(tableView, indexPath);
    }
    
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editingStyle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didSelectRowAtIndexPathCompletion) {
        _didSelectRowAtIndexPathCompletion(tableView, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didDeselectRowAtIndexPathCompletion) {
        _didDeselectRowAtIndexPathCompletion(tableView, indexPath);
    }
}





@end
