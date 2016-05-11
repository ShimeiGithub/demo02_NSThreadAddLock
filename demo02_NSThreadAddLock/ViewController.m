//
//  ViewController.m
//  demo02_NSThreadAddLock
//
//  Created by LuoShimei on 16/5/11.
//  Copyright © 2016年 罗仕镁. All rights reserved.
//

#import "ViewController.h"
/** 初始化总的售票数目 */
#define ALLTICKETS 20

@interface ViewController ()
/** 存储当前剩余车票的数量 */
@property(nonatomic,assign) NSInteger countOfTickets;

/** 为线程加锁 */
@property(nonatomic,strong) NSLock *lock;

@end

@implementation ViewController
#pragma mark=====懒加载=====
- (NSLock *)lock{
    if (_lock == nil) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

/** 售票任务 */
- (void)sale{
    NSThread *currentThread = [NSThread currentThread];
    while (YES) {
        //进入售票先给当前的线程加锁
        [self.lock lock];
        if (self.countOfTickets > 0) {
            //输出当前售票的线程是哪个
            NSLog(@"%@正在出售第%ld张票",currentThread.name,1 + ALLTICKETS - self.countOfTickets);
            //让当前线程睡眠0.5秒，模拟卖票间隔为0.5秒时间
            [NSThread sleepForTimeInterval:0.5];
            
            //票卖掉一张少一张
            _countOfTickets--;
            
            //售票结束后为当前线程解锁
            [self.lock unlock];
            
        }else{
            NSLog(@"票已售完");
            //为当前线程解锁
            [self.lock unlock];
            break;
        }
    }
}

#pragma mark=====关联方法====
/** 点击就开始售票 */
- (IBAction)saleTickets:(id)sender {
    
    //创建线程1
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil] ;
    //创建线程2
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
    
    //创建线程3
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
    
    
    //设置线程的名字
    thread1.name = @"1号售票员";
    thread2.name = @"2号售票员";
    thread3.name = @"3号售票员";
    
    //启动线程
    [thread1 start];
    [thread2 start];
    [thread3 start];
    
}

#pragma mark=====系统方法=====
- (void)viewDidLoad {
    [super viewDidLoad];
    /** 初始化票数 */
    self.countOfTickets = ALLTICKETS;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

/**
 * 模拟的结果如下：
 * 
     2016-05-11 15:13:18.504 demo02_NSThreadAddLock[18837:691553] 1号售票员正在出售第1张票
     2016-05-11 15:13:19.007 demo02_NSThreadAddLock[18837:691554] 2号售票员正在出售第2张票
     2016-05-11 15:13:19.511 demo02_NSThreadAddLock[18837:691555] 3号售票员正在出售第3张票
     2016-05-11 15:13:20.016 demo02_NSThreadAddLock[18837:691553] 1号售票员正在出售第4张票
     2016-05-11 15:13:20.522 demo02_NSThreadAddLock[18837:691554] 2号售票员正在出售第5张票
     2016-05-11 15:13:21.027 demo02_NSThreadAddLock[18837:691555] 3号售票员正在出售第6张票
     2016-05-11 15:13:21.532 demo02_NSThreadAddLock[18837:691553] 1号售票员正在出售第7张票
     2016-05-11 15:13:22.037 demo02_NSThreadAddLock[18837:691554] 2号售票员正在出售第8张票
     2016-05-11 15:13:22.540 demo02_NSThreadAddLock[18837:691555] 3号售票员正在出售第9张票
     2016-05-11 15:13:23.045 demo02_NSThreadAddLock[18837:691553] 1号售票员正在出售第10张票
     2016-05-11 15:13:23.547 demo02_NSThreadAddLock[18837:691554] 2号售票员正在出售第11张票
     2016-05-11 15:13:24.051 demo02_NSThreadAddLock[18837:691555] 3号售票员正在出售第12张票
     2016-05-11 15:13:24.553 demo02_NSThreadAddLock[18837:691553] 1号售票员正在出售第13张票
     2016-05-11 15:13:25.058 demo02_NSThreadAddLock[18837:691554] 2号售票员正在出售第14张票
     2016-05-11 15:13:25.563 demo02_NSThreadAddLock[18837:691555] 3号售票员正在出售第15张票
     2016-05-11 15:13:26.067 demo02_NSThreadAddLock[18837:691553] 1号售票员正在出售第16张票
     2016-05-11 15:13:26.571 demo02_NSThreadAddLock[18837:691554] 2号售票员正在出售第17张票
     2016-05-11 15:13:27.076 demo02_NSThreadAddLock[18837:691555] 3号售票员正在出售第18张票
     2016-05-11 15:13:27.581 demo02_NSThreadAddLock[18837:691553] 1号售票员正在出售第19张票
     2016-05-11 15:13:28.084 demo02_NSThreadAddLock[18837:691554] 2号售票员正在出售第20张票
     2016-05-11 15:13:28.587 demo02_NSThreadAddLock[18837:691555] 票已售完
     2016-05-11 15:13:28.588 demo02_NSThreadAddLock[18837:691553] 票已售完
     2016-05-11 15:13:28.588 demo02_NSThreadAddLock[18837:691554] 票已售完
 
 */
