//
//  ViewController.m
//  通知、KVO、代理
//
//  Created by apple on 16/6/11.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 代理设计模式与通知模式的区别：
 代理设计模式：一个对象只能告诉另一个对象发生了什么；
 通知模式：一个对象可以告诉n个对象发生了什么。
 */
#import "ViewController.h"
#import "ZPPerson.h"

@interface ViewController ()

@property (nonatomic, strong) ZPPerson *p1;
@property (nonatomic, strong) ZPPerson *p2;
@property (nonatomic, strong) ZPPerson *p3;

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //通知方法
//    [self notification];
    
    //KVO方法
    [self KVOMethod];
}

#pragma mark ————— 通知方法 —————
- (void)notification
{
    self.p1 = [[ZPPerson alloc] init];
    self.p1.name = @"p1";
    
    self.p2 = [[ZPPerson alloc] init];
    self.p2.name = @"p2";
    
    self.p3 = [[ZPPerson alloc] init];
    self.p3.name = @"p3";
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self.p1 selector:@selector(test) name:@"testNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.p2 selector:@selector(test) name:@"testNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.p3 selector:@selector(test) name:@"restNotification" object:nil];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil];
}

#pragma mark ————— KVO方法 —————
/**
 KVC: Key Value Coding 根据key找到字典中对应的value值，然后把value值赋值给对象的属性；
 KVO: Key Value Observing 根据key找到对象所对应的属性，然后监听这个属性的值是否有改变，如果这个属性值改变的话就会调用相应的系统方法。
 */
- (void)KVOMethod
{
    self.p1 = [[ZPPerson alloc] init];
    self.p1.name = @"p1";
    
    /**
     本类(self)来监听p1对象的name属性值，如果这个属性的值改变的话，系统就会自动调用相应的系统方法；
     NSKeyValueObservingOptionNew用来监听这个属性被改变之后的值；
     NSKeyValueObservingOptionOld用来监听这个属性改变之前的值；
     属性改变前后的值都会在KVO的监听方法中的change参数中显示出来。
     */
    [self.p1 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    self.p1.name = @"p2";  //被监听的属性值改变
}

#pragma mark ————— KVO的监听方法 —————
/**
 keyPath为被监听的对象属性；
 object为那个对象；
 change参数用来显示被监听的属性改变前后的值
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"监听到%@对象的%@属性发生了改变， %@", object, keyPath, change);
}

/**
 在本视图控制器即将销毁的时候要移除之前注册的通知并且也要移除KVO的监听
 */
-(void)dealloc
{
    [self.p1 removeObserver:self forKeyPath:@"name"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.p1];
    [[NSNotificationCenter defaultCenter] removeObserver:self.p2];
    [[NSNotificationCenter defaultCenter] removeObserver:self.p3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
