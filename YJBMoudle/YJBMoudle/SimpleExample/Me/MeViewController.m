//
//  MeViewController.m
//  YJBMediator
//
//  Created by YUJIABO on 2019/4/3.
//  Copyright © 2019 YUJIABO. All rights reserved.
//

#import "MeViewController.h"
#import "PWModuleRouter.h"

@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *mainView;

@end

@implementation MeViewController

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
    return 4;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSArray *titles = @[@"调用不需要传入参数的函数",@"调用需要传入一个参数的函数",@"调用需要传入多个参数的函数",@"调用有返回值的函数"];
    cell.textLabel.text = titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [PWRouter performActionForURL:@"DetailModule://?action=noParmarTest"];
    }
    else if (indexPath.row==1){
        [PWRouter performActionForURL:@"DetailModule://? action= oneParmarTest:" actionParam:@[@(1001),@"1002"]];
    }
    else if (indexPath.row==2){
        
        [PWRouter performActionForURL:@"DetailModule:/?showhandle: oneParmar: twoParmar:" actionParams:@[@[],@{@"age":@"10"},@{@"sex":@"1"}]];
    }
    else if (indexPath.row==3){
        id value = [PWRouter performActionForURL:@"DetailProtocol://?action=returnValueTest"];
        NSLog(@"返回值是%@",value);
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
