//
//  MXViewController.m
//  MXAutoCoding
//
//  Created by Max on 2017/4/27.
//  Copyright © 2017年 maxzhang. All rights reserved.
//

#import "MXViewController.h"
#import "MXTestModel.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height


@interface MXViewController ()

@property (strong, nonatomic) MXTestModel *testModel;

@end

@implementation MXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //使用方法，在需要进行对象序列化的类 引入NSobject分类 #import "NSObject+MXCoding.h" 即可
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame = CGRectMake(0, 100, kScreen_Width/3.0f, 40);
    [saveBtn setTitle:@"save Data" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteBtn.frame = CGRectMake(kScreen_Width/3.0f, 100, kScreen_Width/3.0f, 40);
    [deleteBtn setTitle:@"delete Data" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    getBtn.frame = CGRectMake(kScreen_Width * 2/3.0f, 100, kScreen_Width/3.0f, 40);
    [getBtn setTitle:@"get Data" forState:UIControlStateNormal];
    [getBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(getBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getBtn];
    
}


- (MXTestModel *)testModel
{
    if (!_testModel) {
        _testModel = [[MXTestModel alloc] init];
        _testModel.intVal = 123;
        _testModel.integerVal = 456;
        _testModel.longVal = 1234;
        _testModel.longlongVal = 123456789;
        _testModel.floatVal = 123.4563;
        _testModel.doubleVal = 123.45635333232;
        _testModel.stringVal = @"stringValue";
        _testModel.numberVal = @(100);
        _testModel.arrayVal = @[@"abc", @"efg", @"hij"];
        _testModel.imageVal = [UIImage imageNamed:@"image_test"];
    }
    return _testModel;
}


- (void)saveBtnAction
{
    [self.testModel saveDataToLocalWithUniqueFlagKey:@"testKey"];
}


- (void)deleteBtnAction
{
    [self.testModel removeDataFromLocalWithUniqueFlagKey:@"testKey"];
}


- (void)getBtnAction
{
    MXTestModel *testModel = [[MXTestModel alloc] init];
    testModel = [testModel getDataFromLocalWithUniqueFlagKey:@"testKey"];
    
    NSLog(@"%d", testModel.intVal);
    NSLog(@"%ld", (long)testModel.integerVal);
    NSLog(@"%ld", testModel.longVal);
    NSLog(@"%lld", testModel.longlongVal);
    NSLog(@"%f", testModel.floatVal);
    NSLog(@"%f", testModel.doubleVal);
    NSLog(@"%@", testModel.stringVal);
    NSLog(@"%@", testModel.numberVal);
    NSLog(@"%@", testModel.arrayVal);
    NSLog(@"%@", testModel.imageVal);

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
