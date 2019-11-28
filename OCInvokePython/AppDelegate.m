//
//  AppDelegate.m
//  OCInvokePython
//
//  Created by sijia on 2019/11/28.
//  Copyright © 2019 nari. All rights reserved.
//

#import "AppDelegate.h"
#include "Python.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     //init python
        //get python lib path and set this path as python home directory
        NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"python" ofType:nil inDirectory:nil];
        char home[1024];
        strcpy(home, [fullpath UTF8String]);
        NSLog(fullpath);
        Py_SetPythonHome(home);//设置python运行环境位置
        Py_Initialize();
          if (Py_IsInitialized()) {
              NSLog(@"初始化环境成功");
          }
    //    PyRun_SimpleString("print 'hello'");//say hello see debug output :)
        dispatch_queue_t queue = dispatch_queue_create(0, DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            //执行python脚本
            NSString * docunmentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  firstObject] ;
            NSLog(@"沙盒路径------：%@",docunmentDir);
            NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"python/lib/python2.7/site-packages/matrixParse" ofType:@"py"];
//            NSString * scriptPath =[docunmentDir stringByAppendingPathComponent:@"matrixParse.py"];//也可将python脚本放在沙盒里
            NSString *logPath = [[NSBundle mainBundle] pathForResource:@"python/lib/python2.7/site-packages/Crash2019-11-26_13-52-24" ofType:@"log"];//输入
             //NSString * logPath=[docunmentDir stringByAppendingPathComponent:@"Crash2019-11-26_13-52-24.log"];//也可用沙盒路径作为输入输出
            NSString * outputPath=[docunmentDir stringByAppendingPathComponent:@"output.log"];//输出
            FILE *mainFile = fopen([scriptPath UTF8String], "r");
            PyEval_InitThreads();
            char *argv[] = {[logPath UTF8String],[outputPath UTF8String]};//执行脚本的参数
            PySys_SetArgv(2, argv);//PySys_SetArgv的参数解释：参数1：要输入参数的个数，参数2：参数数组
            int runResult=PyRun_SimpleFile(mainFile, (char *)[[scriptPath lastPathComponent] UTF8String]);//执行脚本
            Py_Finalize();
            NSLog(@"python脚本运行返回：%d----输出路径------：%@",runResult,outputPath);
        });
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
