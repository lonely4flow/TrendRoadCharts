//
//  LFAskRoadViewController.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class LFAskRoadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    - (void)prepareCategoryList
//    {
//    NSMutableArray *arrayM = [NSMutableArray array];
//    
//    AskCategoryModel *sumCategoryModel = [AskCategoryModel new];
//    sumCategoryModel.title = @"总和";
//    // 大小
//    [sumCategoryModel.itemList addObject:[AskItemModel modelWithTitle:@"大小" askTitles:@[@"大",@"小"] isShowBigRoadTxt:NO transformBlock:^(AskRoadInputModel *model, id obj) {
//    NSString *openNums = obj[@"num"];
//    if([NSString isEmpty:openNums]){
//    model.isWaitOpen = YES;
//    }else{
//    NSArray *nums = [openNums componentsSeparatedByString:@","];
//    NSInteger sum = [[nums valueForKeyPath:@"@sum.integerValue"] integerValue];;
//    model.beforeTransformTxt = @(sum).stringValue;
//    model.afterTransformTxt = sum>=23?@"大":@"小";
//    }
//    } fillCellBlock:^(AskRoadOutputModel *outModel,AskRoadChartCollectionViewCell *cell) {
//    if([@"大" isEqualToString:outModel.showTxt]){
//    // 大是红色
//    cell.bgColor = kAskRoadRed;
//    }else{
//    cell.bgColor = kAskRoadBlue;
//    }
//    }]];
//    // 单双
//    [sumCategoryModel.itemList addObject:[AskItemModel modelWithTitle:@"单双" askTitles:@[@"单",@"双"] isShowBigRoadTxt:NO transformBlock:^(AskRoadInputModel *model, id obj) {
//    NSString *openNums = obj[@"num"];
//    if([NSString isEmpty:openNums]){
//    model.isWaitOpen = YES;
//    }else{
//    NSArray *nums = [openNums componentsSeparatedByString:@","];
//    NSInteger sum = [[nums valueForKeyPath:@"@sum.integerValue"] integerValue];;
//    model.beforeTransformTxt = @(sum).stringValue;
//    model.afterTransformTxt = sum%2==0?@"双":@"单";
//    }
//    } fillCellBlock:^(AskRoadOutputModel *outModel,AskRoadChartCollectionViewCell *cell) {
//    if([@"双" isEqualToString:outModel.showTxt]){
//    // 小是蓝色
//    cell.bgColor = kAskRoadBlue;
//    }else{
//    cell.bgColor = kAskRoadRed;
//    }
//    }]];
//    // 龙虎
//    [sumCategoryModel.itemList addObject:[AskItemModel modelWithTitle:@"龙虎" askTitles:@[@"龙",@"虎"] isShowBigRoadTxt:NO transformBlock:^(AskRoadInputModel *model, id obj) {
//    NSString *openNums = obj[@"num"];
//    if([NSString isEmpty:openNums]){
//    model.isWaitOpen = YES;
//    }else{
//    NSArray *nums = [openNums componentsSeparatedByString:@","];
//    NSInteger sum = [[nums valueForKeyPath:@"@sum.integerValue"] integerValue];
//    NSInteger firstNum = [nums.firstObject integerValue];
//    NSInteger lastNum = [nums.lastObject integerValue];
//    model.beforeTransformTxt = @(sum).stringValue;
//    if(firstNum>lastNum){
//    model.afterTransformTxt = @"龙";
//    }else if (firstNum == lastNum){
//    model.afterTransformTxt = @"和";
//    }else{
//    model.afterTransformTxt = @"虎";
//    }
//    
//    }
//    } fillCellBlock:^(AskRoadOutputModel *outModel,AskRoadChartCollectionViewCell *cell) {
//    if([@"龙" isEqualToString:outModel.showTxt]){
//    // 龙是红色
//    cell.bgColor = kAskRoadRed;
//    }else if([@"和" isEqualToString:outModel.showTxt]){
//    // 和是绿色
//    cell.bgColor = kAskRoadGreen;
//    }else{
//    cell.bgColor = kAskRoadBlue;
//    }
//    }]];
//    [arrayM addObject:sumCategoryModel];
//    
//    NSArray *colTitles = @[@"第一球",@"第二球",@"第三球",@"第四球",@"第五球"];
//    for(NSInteger i=0;i<colTitles.count;i++){
//    AskCategoryModel *categoryModel = [AskCategoryModel new];
//    categoryModel.title = colTitles[i];
//    // 号码
//    [categoryModel.itemList addObject:[AskItemModel modelWithTitle:@"球号" askTitles:nil isShowBigRoadTxt:YES transformBlock:^(AskRoadInputModel *model, id obj) {
//    NSString *openNums = obj[@"num"];
//    if([NSString isEmpty:openNums]){
//    model.isWaitOpen = YES;
//    }else{
//    NSArray *nums = [openNums componentsSeparatedByString:@","];
//    NSString *numTxt = nums[i];
//    model.beforeTransformTxt = numTxt;
//    model.afterTransformTxt = numTxt;
//    }
//    } fillCellBlock:^(AskRoadOutputModel *outModel,AskRoadChartCollectionViewCell *cell) {
//    if([outModel.showTxt integerValue]%2==0){
//    // 双是蓝色
//    cell.bgColor = kAskRoadBlue;
//    }else{
//    cell.bgColor = kAskRoadRed;
//    }
//    }]];
//    // 大小
//    [categoryModel.itemList addObject:[AskItemModel modelWithTitle:@"大小" askTitles:@[@"大",@"小"] isShowBigRoadTxt:NO transformBlock:^(AskRoadInputModel *model, id obj) {
//    NSString *openNums = obj[@"num"];
//    if([NSString isEmpty:openNums]){
//    model.isWaitOpen = YES;
//    }else{
//    NSArray *nums = [openNums componentsSeparatedByString:@","];
//    NSString *numTxt = nums[i];
//    NSInteger num = [numTxt integerValue];
//    model.beforeTransformTxt = numTxt;
//    model.afterTransformTxt = num>=5?@"大":@"小";
//    }
//    } fillCellBlock:^(AskRoadOutputModel *outModel,AskRoadChartCollectionViewCell *cell) {
//    if([@"小" isEqualToString:outModel.showTxt]){
//    // 小是蓝色
//    cell.bgColor = kAskRoadBlue;
//    }else{
//    cell.bgColor = kAskRoadRed;
//    }
//    }]];
//    // 单双
//    [categoryModel.itemList addObject:[AskItemModel modelWithTitle:@"单双" askTitles:@[@"单",@"双"] isShowBigRoadTxt:NO transformBlock:^(AskRoadInputModel *model, id obj) {
//    NSString *openNums = obj[@"num"];
//    if([NSString isEmpty:openNums]){
//    model.isWaitOpen = YES;
//    }else{
//    NSArray *nums = [openNums componentsSeparatedByString:@","];
//    NSString *numTxt = nums[i];
//    NSInteger num = [numTxt integerValue];
//    model.beforeTransformTxt = numTxt;
//    model.afterTransformTxt = num%2==0?@"双":@"单";
//    }
//    } fillCellBlock:^(AskRoadOutputModel *outModel,AskRoadChartCollectionViewCell *cell) {
//    if([@"双" isEqualToString:outModel.showTxt]){
//    // 双是蓝色
//    cell.bgColor = kAskRoadBlue;
//    }else{
//    cell.bgColor = kAskRoadRed;
//    }
//    }]];
//    [arrayM addObject:categoryModel];
//    }
//    self.categoryList = arrayM;
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}