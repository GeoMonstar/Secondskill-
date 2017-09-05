//
//  ViewController.m
//  miaoShaTest
//
//  Created by Monstar on 2017/9/4.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import "ViewController.h"
#import "JQTableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_myTableView;
    NSArray *_dataArray;
    NSArray *_cellidArr;
    NSMutableDictionary *_dataDic;
   
}

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void) appWillEnterForegroundNotification{
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    //申请一个后台执行的任务 大概10分钟 如果时间更长的话需要借助默认音频等
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
     //程序进入后台通知 
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    //    模拟数据
    //    _dataArray = @[@"123",@"1232",@"1123",
    //                   @"3355",@"5566",@"7788",
    //                   @"1541",@"6321",@"2334",@"1234"];
    
    //    测试倒计时同步准确性
    _dataArray = @[@"120",@"120",@"120",
                   @"120",@"120",@"120",
                   @"120",@"120",@"120",@"120"];
    
    _cellidArr = @[@"a",@"b",@"c",
                   @"d",@"e",@"f",
                   @"g",@"h",@"i",@"j"];
    _dataDic = @{}.mutableCopy;
    [self getTimeStrWith:_dataArray and:_cellidArr];
    
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 375, 667) style:UITableViewStylePlain];
    _myTableView.rowHeight = 150;
    [_myTableView registerClass:[JQTableViewCell class] forCellReuseIdentifier:@"JQTableViewCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"JQTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"JQTableViewCell"];
    _myTableView.delegate   = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JQTableViewCell *cell = [JQTableViewCell initWith:tableView];
    
    cell.cellID = _cellidArr[indexPath.row];
    
    cell.timeLineLabel.text = [_dataDic objectForKey:cell.cellID];
    
    return cell;
}


- (void)getTimeStrWith:(NSArray *)timeStrArr and:(NSArray *)cellIdArr{
    
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    
    [timeStrArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block int timeout=[timeStrArr[idx] intValue]; //倒计时时间
        
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
        dispatch_source_set_event_handler(_timer, ^{
            
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_dataDic setObject:@"停止秒杀"  forKey:cellIdArr[idx]];
                    [_myTableView reloadData];
                });
            }else{
                int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%d分%.2d秒后停止秒杀",minutes, seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"time === %@",strTime);
                    [_dataDic setObject:strTime forKey:cellIdArr[idx]];
                    [_myTableView reloadData];
                });
                timeout--;
            }
            
        });
        dispatch_resume(_timer);
    }];
//    for (int i = 0; i< timeStrArr.count; i++) {
//        
//        
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

