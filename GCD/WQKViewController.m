//
//  ViewController.m
//  GCD
//
//  Created by AlexCorleone on 2017/6/7.
//  Copyright © 2017年 AlexCorleone. All rights reserved.
//

#import "WQKViewController.h"

@interface WQKViewController ()

@end

@implementation WQKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self aboutGCD];
    [self deepDectedGCD];
}

#pragma mark - public Method

#pragma mark - private Method
- (void)aboutGCD
{
    //系统创建的Queue
    //一个默认的与主线程绑定的队列，称之为主队列,主线程是在main()函数被调用之前被创建，创建主线程的同时主队列也一起被创建，提交到主队列的blocks将会在主线程执行。串行队列（serial Queue）
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    //一个众所周知的全局队列，随之绑定这一个优先级标志  并发队列(concurrent Queue)
    //identifier 标识全局队列的优先级
        //DISPATCH_QUEUE_PRIORITY_HIGH          高优先级    （最先添加执行的优先级）
        //DISPATCH_QUEUE_PRIORITY_DEFAULT       默认优先级   （在高优先级之后添加执行）
        //DISPATCH_QUEUE_PRIORITY_LOW           低优先级    （在默认优先级之后添加执行）
        //DISPATCH_QUEUE_PRIORITY_BACKGROUND    后台模式    （在所有高优先级都被添加到执行队列并且系统将在后台的当前Queue执行任务才被添加并执行）
    //flags 保留参数，传NULL
    //注意:如果global Queue不存在的情况下，该方法可能返回一个NULL对象。
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //创建执行一次的任务
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //10秒后执行Block，具体到block可能是11秒
        });
    }

    //自己创建 serial queue （串行队列）
    const char * alexSerialLabel = "Alex.Serial.Identifier";
    dispatch_queue_t customSerialQueue = dispatch_queue_create(alexSerialLabel, DISPATCH_QUEUE_SERIAL);
    
    //自己创建 concurrent queue（并发队列）
    const char * alexConcurrentLabel = "Alex.Concurrenr.identifier";
    dispatch_queue_t customConcurrentQueue = dispatch_queue_create(alexConcurrentLabel, DISPATCH_QUEUE_CONCURRENT);
    
    const char *serialLabel = dispatch_queue_get_label(customSerialQueue);
    const char *concurrentLabel = dispatch_queue_get_label(customConcurrentQueue);
    const char *mainLabel = dispatch_queue_get_label(mainQueue);
    const char *globalLabel = dispatch_queue_get_label(globalQueue);
//        NSLog(@"-- %s -- %s -- %s -- %s --", serialLabel, concurrentLabel, mainLabel, globalLabel);
//    {
//        //dispatch_group_t
//        
//        dispatch_async(customConcurrentQueue, ^{
//            
//            dispatch_group_t group = dispatch_group_create();
//            dispatch_group_async(group, globalQueue, ^{
//                [self doNothingButWithLongTime];
//                [self doNothingButWithLongTime];
//                NSLog(@"111111 %@", [NSThread currentThread]);
//            });
//            dispatch_group_async(group, globalQueue, ^{
//                NSLog(@"222222 %@", [NSThread currentThread]);
//            });
//            dispatch_group_enter(group);
//            [self doNothingButWithLongTime];
//            NSLog(@"enter ----- leave %@", [NSThread currentThread]);
//            dispatch_group_leave(group);
//            dispatch_group_async(group, globalQueue, ^{
////                [self doNothingButWithLongTime];
////                [self doNothingButWithLongTime];
//                NSLog(@"333333 %@", [NSThread currentThread]);
//            });
//            [self doNothingButWithLongTime];
////            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
////            dispatch_group_notify(group, globalQueue, ^{
////                NSLog(@"group Exeture End %@", [NSThread currentThread]);
////            });
//            NSLog(@"-------- %@", [NSThread currentThread]);
//        });
//    }
    
    

//    dispatch_async(customConcurrentQueue,  ^{
//        NSLog(@"--- 11111 asyn %@", [NSThread currentThread]);
//        dispatch_sync(customSerialQueue, ^{
//            [self doNothingButWithLongTime];
//            NSLog(@"--- 22222 syn %@", [NSThread currentThread]);
//        });
//        dispatch_sync(customSerialQueue, ^{
//            NSLog(@"--- 333333 syn %@", [NSThread currentThread]);
//        });
//    });
    
    
    //同步提交
//    [self aboutSyncQueue1:customSerialQueue queue2:customConcurrentQueue];
    //异步提交
    [self aboutAsyncQueue1:customSerialQueue queue2:customConcurrentQueue];
    //set targetQueue
//    [self aboutSetTargetQueue];
//    [self aboutDispatchSemaphore];
}

/*同步提交需要等待上一个任务执行完成，
  如果同步内部嵌套了同步提交的任务，
  那么必须内部提交的任务执行完之后才会回到上一个未执行完成的任务。
  同步提交到串行队列后，任务内不能再嵌套提交到串行队列的任务否则程序崩溃。*/
- (void)aboutSyncQueue1:(dispatch_queue_t)customSerialQueue
                 queue2:(dispatch_queue_t) customConcurrentQueue
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //同步提交   synchronous
    //Submits a block for synchronous execution on a dispatch queue.
    dispatch_queue_t synSerialQueue = customSerialQueue;
    dispatch_queue_t synConcurrentQueue = customConcurrentQueue;
    NSLog(@"syn serialQueue -------------------");
    //however * dispatch_sync() will not return until the block has finished
    
    
//    dispatch_sync(synSerialQueue, ^{
//        [self doNothingButWithLongTime];
//        NSLog(@"------- 0000%@", [NSThread currentThread]);
//    });
//    dispatch_sync(synSerialQueue, ^{
//        NSLog(@"------- 1111%@", [NSThread currentThread]);
//    });
//    NSLog(@"---- 提交结束 ---");
    
    
//    dispatch_async(globalQueue, ^{
//        NSLog(@"---- 0000%@", [NSThread currentThread]);
//        dispatch_sync(synConcurrentQueue, ^{
//            dispatch_sync(synSerialQueue, ^{
//                NSLog(@"----  2222%@", [NSThread currentThread]);
//            });
//            NSLog(@"---- 1111%@", [NSThread currentThread]);
//        });
//        dispatch_sync(synConcurrentQueue, ^{
//            NSLog(@"----  3333%@", [NSThread currentThread]);
//        });
//        dispatch_sync(synConcurrentQueue, ^{
//            NSLog(@"---- 6666%@", [NSThread currentThread]);
//        });
//        NSLog(@"---- 提交结束 ---");
//    });
    
    
//    dispatch_sync(synSerialQueue, ^{
//        NSLog(@"----- 11111 %@", [NSThread currentThread]);
//        dispatch_sync(synSerialQueue, ^{
//            NSLog(@"----- 22222 %@", [NSThread currentThread]);
//        });
//    });
    
//    dispatch_async(synSerialQueue, ^{
//        dispatch_sync(synConcurrentQueue, ^{
//            NSLog(@"----- 11111 %@", [NSThread currentThread]);
//            dispatch_sync(synSerialQueue, ^{
//                NSLog(@"----- 22222 %@", [NSThread currentThread]);
//            });
//        });
//    });
    
    NSLog(@"syn concurrentQueue -------------------");
    
    dispatch_async(synSerialQueue, ^{
        NSLog(@"同步提交任务到并发队列 0000%@", [NSThread currentThread]);
        dispatch_sync(synConcurrentQueue, ^{
            NSLog(@"同步提交任务到并发队列 1111%@", [NSThread currentThread]);
            dispatch_async(synSerialQueue, ^{
                [self doNothingButWithLongTime];
                [self doNothingButWithLongTime];
                NSLog(@"同步提交任务到串行队列 2222%@", [NSThread currentThread]);
            });
            dispatch_async(synSerialQueue, ^{
                NSLog(@"同步提交任务到串行队列 3333%@", [NSThread currentThread]);
            });
        });
    });
//    NSLog(@"syn concurrentQueue -------------------");
    
//    dispatch_async(globalQueue, ^{
//        NSLog(@"---- 0000%@", [NSThread currentThread]);
//        dispatch_sync(customConcurrentQueue, ^{
//            NSLog(@"---- 1111%@", [NSThread currentThread]);
//            dispatch_sync(synSerialQueue, ^{
//                [self doNothingButWithLongTime];
//                NSLog(@"---- 2222%@", [NSThread currentThread]);
//            });
//            dispatch_sync(synSerialQueue, ^{
//                NSLog(@"---- 3333%@", [NSThread currentThread]);
//            });
//            NSLog(@"---- 提交结束 ---");
//        });
//    });
//    NSLog(@"---- 主线程继续 ----");
    
//    dispatch_sync(synConcurrentQueue, ^{
//        [self doNothingButWithLongTime];
//        NSLog(@"同步提交任务到并发队列 4444%@", [NSThread currentThread]);
//    });
//    dispatch_sync(synConcurrentQueue, ^{
//        NSLog(@"同步提交任务到并发队列 5555%@", [NSThread currentThread]);
//    });


    /*
     2017-06-07 16:37:10.861 GCD[4491:585762] 同步提交任务到并发队列 1111
     2017-06-07 16:37:31.062 GCD[4491:585762] 同步提交任务到串行队列 2222
     2017-06-07 16:37:51.086 GCD[4491:585762] 同步提交任务到串行队列 3333
     2017-06-07 16:37:51.086 GCD[4491:585762] 同步提交任务到并发队列 4444
     2017-06-07 16:37:51.086 GCD[4491:585762] 同步提交任务到并发队列 5555
     */
    
    //    SEL sel = @selector(submitFunctionForExecution:);
    //    dispatch_sync_f(customSerialQueue, @"context", sel);
}

- (void)aboutAsyncQueue1:(dispatch_queue_t)customSerialQueue
                 queue2:(dispatch_queue_t) customConcurrentQueue
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //异步提交   Asynchronous
    //Submits a block for asynchronous execution on a dispatch queue.
    dispatch_queue_t asynSerialQueue = customSerialQueue;
    dispatch_queue_t asynConcurrentQueue = customConcurrentQueue;
    //NSLog(@"asyn serialQueue  (serialQueue)-------------------");

    //异步提交不需要等待，并且默认开辟的子线程，提交到队列的任务会在子线程执行，所以任务提交能够很快在当前线程执行完毕，不会阻塞当前线程，但是提交的任务执行过程和提交到串行队列还是并行队列有关。
    //如果是提交到串行队列，那么提交的任务会按照提交顺序，依次执行。
//    dispatch_async(asynSerialQueue, ^{
//        NSLog(@"----  1111%@", [NSThread currentThread]);
//        dispatch_async(asynSerialQueue, ^{
//            NSLog(@"---- 2222%@", [NSThread currentThread]);
//        });
//        [self doNothingButWithLongTime];
//        NSLog(@"---- 3333%@", [NSThread currentThread]);
//    });
//    dispatch_async(asynSerialQueue, ^{
//        [self doNothingButWithLongTime];
//        NSLog(@"----  4444%@", [NSThread currentThread]);
//    });
//    NSLog(@"---- 提交结束---");
    
    //(@"asyn serialQueue (concurrentQueue) -------------------");
    
//    dispatch_async(asynSerialQueue, ^{
//        [self doNothingButWithLongTime];
//        NSLog(@"异步提交任务到串行队列  1111");
//        dispatch_async(asynConcurrentQueue, ^{
//            [self doNothingButWithLongTime];
//            NSLog(@"异步提交任务到并发队列  2222");
//        });
//        dispatch_async(asynConcurrentQueue, ^{
//            [self doNothingButWithLongTime];
//            NSLog(@"异步提交任务到并发队列  3333");
//        });
//        NSLog(@"异步提交任务到串行队列  4444");
//    });
//    dispatch_async(asynSerialQueue, ^{
//        NSLog(@"异步提交任务到串行队列  5555");
//    });
    
    //NSLog(@"asyn concurrentQueue (serialQueue) -------------------");
//    dispatch_async(asynConcurrentQueue, ^{
//        [self doNothingButWithLongTime];
//        NSLog(@"异步提交任务到并发队列 1111");
//        dispatch_async(asynSerialQueue, ^{
//            [self doNothingButWithLongTime];
//            NSLog(@"异步提交任务到串行队列 2222");
//        });
//        dispatch_async(asynSerialQueue, ^{
//            [self doNothingButWithLongTime];
//            NSLog(@"异步提交任务到串行队列 3333");
//        });
//        NSLog(@"异步提交任务到串行队列 4444");
//    });
//    dispatch_async(asynConcurrentQueue, ^{
//        NSLog(@"异步提交任务到串行队列 5555");
//    });
    
    /*
     2017-06-07 16:54:36.653 GCD[4618:595200] 异步提交任务到串行队列 5555
     2017-06-07 16:54:58.616 GCD[4618:595186] 异步提交任务到并发队列 1111
     2017-06-07 16:54:58.616 GCD[4618:595186] 异步提交任务到串行队列 4444
     2017-06-07 16:55:20.638 GCD[4618:595188] 异步提交任务到串行队列 2222
     2017-06-07 16:55:42.508 GCD[4618:595188] 异步提交任务到串行队列 3333
     */
    
    //NSLog(@"asyn concurrentQueue (concurrentQueue) -------------------");
    
    //异步提交到并发队列的任务执行顺序具有不可预测性，因为并发队列在执行异步任务时，会创建多条子线程(具体创建多少条与最大并发数有关)，每个提交到并发队列的block被分配到不同的子线程执行。所以执行顺序与执行block的耗时有关，耗时较少的会先执行完毕，耗时最多的block最后执行完毕。
//    dispatch_async(asynConcurrentQueue, ^{
//        NSLog(@"---- 1111%@", [NSThread currentThread]);
//        dispatch_async(asynConcurrentQueue, ^{
//            NSLog(@"---- 2222%@", [NSThread currentThread]);
//        });
//        [self doNothingButWithLongTime];
//        [self doNothingButWithLongTime];
//        NSLog(@"---- 3333%@", [NSThread currentThread]);
//    });
//    dispatch_async(asynConcurrentQueue, ^{
//        [self doNothingButWithLongTime];
//        NSLog(@"---- 4444%@", [NSThread currentThread]);
//    });
//    NSLog(@"---- 提交结束---");

    
    /*
     2017-06-07 16:51:32.976 GCD[4599:593523] 异步提交任务到并发队列 1111
     2017-06-07 16:51:32.976 GCD[4599:593538] 异步提交任务到并发队列 4444
     2017-06-07 16:51:32.976 GCD[4599:593523] 异步提交任务到并发队列 3333
     2017-06-07 16:51:32.976 GCD[4599:593524] 异步提交任务到并发队列 2222
     */
//    NSLog(@"%@", dispatch_get_main_queue());
//    NSLog(@"%@", dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    
    
    dispatch_async(asynConcurrentQueue, ^{
        [self doNothingButWithLongTime];
        NSLog(@"111%@", [NSThread currentThread]);
    });
    dispatch_async(asynConcurrentQueue, ^{
        NSLog(@"222%@", [NSThread currentThread]);
    });
    dispatch_barrier_async(asynConcurrentQueue, ^{
        NSLog(@"barrier : 333%@", [NSThread currentThread]);
    });
    dispatch_async(asynConcurrentQueue, ^{
        NSLog(@"444%@", [NSThread currentThread]);
    });
    dispatch_async(asynConcurrentQueue, ^{
        NSLog(@"555%@", [NSThread currentThread]);
    });
    NSLog(@"---- 任务提交结束 ----");
    
    /*
     2017-06-10 10:34:46.452 GCD[7716:1277374] 222<NSThread: 0x608000075500>{number = 3, name = (null)}
     2017-06-10 10:35:08.015 GCD[7716:1277391] 111<NSThread: 0x600000070c80>{number = 4, name = (null)}
     2017-06-10 10:35:08.015 GCD[7716:1277391] barrier : 333<NSThread: 0x600000070c80>{number = 4, name = (null)}
     2017-06-10 10:35:08.016 GCD[7716:1277391] 444<NSThread: 0x600000070c80>{number = 4, name = (null)}
     2017-06-10 10:35:08.016 GCD[7716:1277373] 555<NSThread: 0x608000075500>{number = 5, name = (null)}
*/
}

- (void)aboutSetTargetQueue
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t globalHighQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_queue_t globalLowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_queue_t globalBackgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);

    dispatch_queue_t customQueue = dispatch_queue_create("Alex.custom.identifier.WQK", DISPATCH_QUEUE_CONCURRENT);
    
    //dispatch_queue_create 创建队列默认优先级是DISPATCH_QUEUE_PRIORITY_DEFAULT
    //通过dispatch_set_target_queue可以指定队列的优先级

    dispatch_set_target_queue(customQueue, globalHighQueue);
    
    dispatch_async(customQueue, ^{
        [self doNothingButWithLongTime];
        NSLog(@"11111 ---1 前三个执行完毕");
    });
    dispatch_async(customQueue, ^{
        NSLog(@"11111 ---2");
    });
    dispatch_async(customQueue, ^{
        NSLog(@"11111 ---3");
    });

    dispatch_set_target_queue(customQueue, globalQueue);
    
    dispatch_async(customQueue, ^{
        NSLog(@"11111 --- 4");
    });
    dispatch_async(customQueue, ^{
        [self doNothingButWithLongTime];
        NSLog(@"11111 ---5 中间两个执行完毕");
    });

    dispatch_set_target_queue(customQueue, globalLowQueue);
    
    dispatch_async(customQueue, ^{
        [self doNothingButWithLongTime];
        NSLog(@"11111 ---6 后三个执行完毕");
    });
    dispatch_async(customQueue, ^{
        NSLog(@"11111 ---7");
    });
    dispatch_async(customQueue, ^{
        NSLog(@"11111 ---8");
    });
}

- (void)aboutDispatchSemaphore
{
    [self inlineBlock:^NSInteger(NSString *str1, NSString *str2) {
        return 99;
    }];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //自己创建 serial queue （串行队列）
    const char * alexSerialLabel = "Alex.Serial.Identifier";
    dispatch_queue_t customSerialQueue = dispatch_queue_create(alexSerialLabel, DISPATCH_QUEUE_SERIAL);
    
    //自己创建 concurrent queue（并发队列）
    const char * alexConcurrentLabel = "Alex.Concurrenr.identifier";
    dispatch_queue_t customConcurrentQueue = dispatch_queue_create(alexConcurrentLabel, DISPATCH_QUEUE_CONCURRENT);
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(-1);
    dispatch_async(globalQueue, ^{
        dispatch_sync(customSerialQueue, ^{
            [self doNothingButWithLongTime];
            NSLog(@"---- 信号即将发送 ----");
            dispatch_semaphore_signal(semaphore);
            dispatch_semaphore_signal(semaphore);

        });
    });
    NSLog(@"---- wait ----");
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"---- wait end ----");
}

- (void)inlineBlock:(NSInteger (^)(NSString *str1, NSString *str2))block
{
    NSInteger (^reslutBlock)(NSString *str1, NSString *str2) =  ^NSInteger (NSString *str1, NSString * str2){
        
        return 100;
    };
    NSInteger result1 = reslutBlock(@"sbjhsjk", @"sjbjks");
    NSInteger result2 = block(@"snsns", @"ssjkdsasjkcn");

    
}

- (void)submitFunctionForExecution:(id)context
{
    NSLog(@"%s   --   %@", __FUNCTION__, context);
}

- (void)doNothingButWithLongTime
{
    for (NSInteger i = 0; i < 10000000000; i++)
    {
    }
}



#pragma mark - GCD 高级使用

- (void)deepDectedGCD
{
//    [self createTimerWithDispatchSource];
    [self getFileDataWith:[[NSBundle mainBundle] pathForResource:@"dataTest" ofType:@".mp3"]];
}


- (void)createTimerWithDispatchSource
{
    //创建一个Timer对象
    dispatch_source_t theTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_queue_create("timer queue",NULL));
    __block int i = 0;
    
    printf("Starting to count by seconds\n");
    //为Timer对象指定回调Block
    dispatch_source_set_event_handler(theTimer, ^{
        printf("%d\n", ++i);
        if (i >= 6) {
            printf("i>6\n");
            dispatch_source_cancel(theTimer);
        }
        if (i == 3) {
            printf("switching to half seconds\n");
            dispatch_source_set_timer(theTimer, DISPATCH_TIME_NOW, NSEC_PER_SEC / 2, 0);
        }
    });
    //为Timer对象指定取消事件的回调Block
    dispatch_source_set_cancel_handler(theTimer, ^{
        printf("dispatch source canceled OK\n");
        //            dispatch_release(theTimer);
//        exit(0);
    });
    
    dispatch_source_set_timer(theTimer, dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC) , NSEC_PER_SEC, 0);
    
    dispatch_resume(theTimer);
    //        dispatch_main();
}


- (void)getFileDataWith:(NSString *)outFilePath
{
    int infd;
    dispatch_source_t    fileSource;
    
    const char *filePath = [outFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    
    infd = open(filePath, O_RDONLY);
    if (infd == -1) {
        perror(filePath);
        //            exit(1);
    }
    
    if (fcntl(infd, F_SETFL, O_NONBLOCK) != 0) {
        perror(filePath);
        //            exit(1);
    }
    
    fileSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, infd, 0, dispatch_queue_create("read source queue",NULL));
    dispatch_source_set_event_handler_f( fileSource, readFileData);
    dispatch_source_set_cancel_handler_f( fileSource, cancelSource);
    // setting the context pointer to point to the source itself means the functions will get the source
    // as a paremeter, from there they can get all the information they need.
    dispatch_set_context(fileSource, (__bridge void * _Nullable)(fileSource));
    dispatch_resume(fileSource);
    
    dispatch_main();

}

void readFileData(void* theSource) {
    char buffer[1000];//一次读取的文件大小
    size_t estimated = dispatch_source_get_data((__bridge dispatch_source_t _Nonnull)(theSource));
    printf("Estimated bytes available: %ld\n", estimated);
    ssize_t actual = read((int)dispatch_source_get_handle((__bridge dispatch_source_t _Nonnull)(theSource)), buffer, sizeof(buffer));
    if (actual == -1) {
        if (errno != EAGAIN) {
            perror("read");
            exit(-1);
        }
    } else {
        if  (estimated>actual) {
            printf("  bytes read: %ld\n", actual);
        } else {
            // end of file has been reached.
            printf("  last bytes read: %ld\n", actual);
            dispatch_source_cancel((__bridge dispatch_source_t _Nonnull)(theSource));
        }
    }
}


void cancelSource(void* theSource) {
    close((int)dispatch_source_get_handle((__bridge dispatch_source_t _Nonnull)(theSource)));
    //    dispatch_release(theSource);
    //    dispatch_release(dispatch_get_current_queue());
    printf("Everything is finished, goodbye.\n");
    exit(0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"  ---- touch began click ---");
}

@end
