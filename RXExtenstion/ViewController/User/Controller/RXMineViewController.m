//
//  RXMineViewController.m
//  RXExtenstion
//
//  Created by srx on 16/5/27.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXMineViewController.h"
#import "RXDataModel.h"
#import "RXConstant.h"
#import "RXRandom.h"

#import "RXMineHeader.h"
#define imageString @"https://avatars3.githubusercontent.com/u/16399242?v=3&amp.png"

#import "RXMineWebViewController.h"

@interface RXMineViewController ()<UITableViewDelegate, UITableViewDataSource>
{

    UITableView    * _tableView;
    NSMutableArray * _dataSouceArr;
    
    RXUser         * _userModel;
    RXMineHeader   * _header;
    CGFloat          _headerHeight;
}
@end

@implementation RXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}


- (void)configUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight - TabbarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];

    _headerHeight = 150;
    _header = [[RXMineHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _headerHeight)];
//    _header.backgroundColor = [UIColor redColor];
    [_tableView addSubview:_header];
    //table 内部向下移动
    _tableView.contentInset = UIEdgeInsetsMake(_headerHeight, 0, 0, 0);
    
    _dataSouceArr = [[NSMutableArray alloc] init];
    [self AddFalseData];
}

- (void)AddFalseData {
    //假数据，以真数据形式赋值

    //header
    NSDictionary * userDic = @{
                               @"user_id"      : IntTranslateStr(1881142),
                               @"user_avater"  : imageString,
                               @"user_backImg" : [RXRandom randomImageURL],
                               @"user_desc"    : @"懂得太少，表现太多；才华太少，锋芒太多"
                               };
    _userModel = [RXUser userWithDict:userDic];
    [_header setHeaderData:_userModel];
    
    
    //cell 假数据
    for(NSInteger i = 0; i < 3; i ++) {
        RXMineModel * model = [[RXMineModel alloc] init];
        if(i == 0) {
            model.title = @"我的github.com";
            model.webUrl = @"https://github.com/srxboys";
        }
        else if(i == 1) {
            model.title = @"我的新浪微博";
            model.webUrl = @"https://weibo.com/srxboys";
        }
        else if(i == 2) {
            model.title = @"我的百度网盘";
            model.webUrl = @"http://pan.baidu.com/s/1hqH9ZNI";
        }
        
        [_dataSouceArr addObject:model];
    }
    
    
//    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //table 第一次，从顶部显示
    _tableView.contentOffset = CGPointMake(0, -_headerHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSouceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    RXMineModel * model = _dataSouceArr[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
   
    CGFloat top = offsetY;
    CGFloat left = 0;
    CGFloat width = ScreenWidth;
    CGFloat height = _headerHeight;
//     RXLog(@"offsetY=%.2f====_headerHeight=%.2f", offsetY, _headerHeight);
    RXLog(@"x=%.2f==y=%2.f==width=%.2f===height=%.2f", left, top, width, height);
    
    if(offsetY <= -_headerHeight) {
        //向下滑动
        left = ceilf(fabs(offsetY) - _headerHeight);
        width = left * 2.0 + ScreenWidth;
        height = left + _headerHeight;
        left = - left;
    }
    else {
        //向上滑动
        top = - ceilf(fabs(offsetY)) + ceilf(fabs(offsetY) - _headerHeight);
    }

    
    _header.frame = CGRectMake(left, top, width, height);
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    
    RXMineModel * model = _dataSouceArr[row];
    RXMineWebViewController * webController= [[RXMineWebViewController alloc] init];
    webController.model = model;
    //隐藏 tabBar
    webController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
