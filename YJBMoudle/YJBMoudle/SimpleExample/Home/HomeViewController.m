//
//  HomeViewController.m
//  YJBMediator
//
//  Created by YUJIABO on 2019/4/3.
//  Copyright © 2019 YUJIABO. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailProtocol.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *mainView;
@end

@implementation HomeViewController

- (UITableView*)mainView
{
    if (!_mainView) {
        CGRect mainBounds = [UIScreen mainScreen].bounds;
        _mainView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,mainBounds.size.width, mainBounds.size.height) style:UITableViewStylePlain];
        _mainView.delegate = self;
        _mainView.dataSource = self;
    }
    return _mainView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSArray *titles = @[@"获取DetailModule实例对象",@"获取DetailModule实例对象并缓存到内存中",@"获取DetailModule实例对象并进行参数回调"];
    cell.textLabel.text = titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
       id <DetailProtocol> detailM = [PWRouter interfaceForProtocol:@protocol(DetailProtocol)];
        [detailM showDetailMessage:@"调用DetailModule函数showDetailMessage:成功"];
    }
    else if (indexPath.row==1){
        id <DetailProtocol> detailM1 = [PWRouter interfaceCacheModuleForProtocol:@protocol(DetailProtocol)];
        id <DetailProtocol> detailM2 = [PWRouter interfaceCacheModuleForProtocol:@protocol(DetailProtocol)];
        if (detailM1==detailM2) {
            NSLog(@"两次获取到的DetailModule实例对象相同");
        }
    }
    else if (indexPath.row==2){
        id <DetailProtocol> detailM = [PWRouter interfaceForProtocol:@protocol(DetailProtocol)];
        [detailM showAlterViewCallBackInViewController:self];
        detailM.callbackBlock = ^(id parameter) {
            NSLog(@"回传回来的参数是%@",parameter);
        };
    }
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
