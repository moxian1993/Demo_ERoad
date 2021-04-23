//
//  FNAllGoodsSubController.m
//  ERoadDemo
//
//  Created by Admin on 2021/4/21.
//

#import "FNAllGoodsSubController.h"
#import "FNAllGoodsSubCell.h"

#import "ERoadDemo-Swift.h"

@interface FNAllGoodsSubController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@end

@implementation FNAllGoodsSubController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.bgColor(@"white");
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    tableView.bgColor(BGCOlOLSTR).addTo(self.view).makeCons(^{
        make.top.left.bottom.equal.superview.constants(0);
        make.width.constants(100);
    });
    
    tableView.rowHeight = 50;
    tableView.contentInset = UIEdgeInsetsMake(-35, 0, -39, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:FNAllGoodsSubCell.class forCellReuseIdentifier:NSStringFromClass(FNAllGoodsSubCell.class)];
    
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FNAllGoodsSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(FNAllGoodsSubCell.class) forIndexPath:indexPath];
    
    cell.textLabel.text = @"香蕉/牛油果";
    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f", scrollView.contentOffset.y);
    
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
