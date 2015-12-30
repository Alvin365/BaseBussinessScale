//
//  ContactsIndexsView.m
//  showTalence
//
//  Created by Alvin on 15/9/8.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import "ContactsIndexsView.h"

@implementation TitlesIndexsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    if (self.imageView.image) {
        self.imageView.frame = CGRectMake(self.centerX-7.5, self.centerY-7.5, 15, 15);
    }else{
        self.textLabel.frame = CGRectMake(0, 0, self.width, self.height);
    }
}

@end

@interface ContactsIndexsView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation ContactsIndexsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.bounces = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.userInteractionEnabled = YES;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return self;
}
#pragma  mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInden = @"cellInden";
    TitlesIndexsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    if (!cell) {
        cell = [[TitlesIndexsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInden];
        cell.textLabel.textColor = ALTextColor;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < _dataSource.count) {
        NSString *name = _dataSource[indexPath.row];
        UIImage *image = [UIImage ALImageWithName:name];
        if (image) {
            cell.imageView.image = image;
        }else{
            cell.textLabel.text = name;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.callBack) {
        NSString *name = _dataSource[indexPath.row];
        self.callBack(name);
    }
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    self.frame = CGRectMake(screenWidth-self.width, ((screenHeight-64)-_dataSource.count*20)/2.0f, self.width, _dataSource.count*20);
    _tableView.frame = self.bounds;
    [self.tableView reloadData];
}

@end
