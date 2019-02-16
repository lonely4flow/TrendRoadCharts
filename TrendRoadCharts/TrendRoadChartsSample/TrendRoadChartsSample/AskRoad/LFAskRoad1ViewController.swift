//
//  LFAskRoad1ViewController.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit
typealias LFRoadTransformInputModelClosure = (_ inputModel:LFRoadInputParamModel,_ obj: AnyObject)->Void

class LFAskRoad1ViewController: UIViewController {

    var showQueue: OperationQueue?
    var askQueue: OperationQueue?
    
    var roadContainerView: UIView!
    
    var itemScrollView: UIScrollView!
    
    var itemSize: CGSize = CGSize(width: 25, height: 25)
    var bigRoadView: LFRoadChartView!
    var panZhuRoadView: LFRoadChartView!
    var bigEyeRoadView: LFRoadChartView!
    var smallRoadView: LFRoadChartView!
    var yueYouRoadView: LFRoadChartView!
    
    var askContainerView: UIView!
    var leftAskView: LFRoadAskTipView!
    var rightAskView: LFRoadAskTipView!
    
    var categoryList: [LFAskRoadCategoryModel] = []
    var selectCategeryIndex: Int = 0
    var selectItemIndex: Int = 0
    var selectItemModel: LFAskRoadItemModel?
    var dataList: [AnyObject] = []
    // MARK: - UI
    override func viewDidLoad() {
        super.viewDidLoad()
        let categoryModel = LFAskRoadCategoryModel()
        categoryModel.title = "总和"
        let bigSmallItemModel = LFAskRoadItemModel()
        bigSmallItemModel.title = "大小"
        bigSmallItemModel.askTitles = ["大","小"]
        bigSmallItemModel.isShowBottomThreeRoad = true
        bigSmallItemModel.transformClosure = {(inputModel:LFRoadInputParamModel, obj: AnyObject) in
            inputModel.beforeTransformTxt = "10"
            inputModel.afterTransformTxt = "大"
        }
        categoryModel.itemList.append(bigSmallItemModel)
        
        let singleDoubleItemModel = LFAskRoadItemModel()
        singleDoubleItemModel.title = "单双"
        singleDoubleItemModel.askTitles = ["单","双"]
        singleDoubleItemModel.isShowBottomThreeRoad = true
        singleDoubleItemModel.transformClosure = {(inputModel:LFRoadInputParamModel, obj: AnyObject) in
            inputModel.beforeTransformTxt = "10"
            inputModel.afterTransformTxt = "双"
        }
        categoryModel.itemList.append(singleDoubleItemModel)
        
        self.categoryList.append(categoryModel)
        self.setupUI()
        self.itemBtnCliked(btn: nil)
        
    }
    func setupUI() -> Void {
        let width: CGFloat = UIScreen.main.lf_width
        //let height: CGFloat = UIScreen.main.lf_height
        // 关闭按钮
        let closeBtn = UIButton(type: .system)
        closeBtn.setTitle("关闭", for: .normal)
        closeBtn.backgroundColor = UIColor.blue
        let closeBtnWidth: CGFloat = 60
        let rightMargin: CGFloat = 20
        closeBtn.frame = CGRect(x: width - closeBtnWidth-rightMargin, y: rightMargin, width: closeBtnWidth, height: 40)
        closeBtn.setTitleColor(UIColor.black, for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        self.view.addSubview(closeBtn)
        
        self.roadContainerView = UIView(frame: CGRect(x: 0, y: 100, width: width, height: 600))
//        self.roadContainerView.backgroundColor = UIColor.lf_rgb(r: 67, g: 85, b: 103)
        self.roadContainerView.backgroundColor = UIColor.purple
        self.view.addSubview(self.roadContainerView)
        
        
        let itemBgView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        itemBgView.backgroundColor = UIColor.lightGray
        self.roadContainerView.addSubview(itemBgView);
        
        self.itemScrollView = UIScrollView(frame: CGRect(x: 100, y: 0, width: width-100, height: 40))
        self.itemScrollView.backgroundColor = UIColor.gray
        itemBgView.addSubview(self.itemScrollView)
        
        self.setupItems()
        
        // 5个图
        let askViewMargin: CGFloat = 10
        let roadTitleWidth: CGFloat = 25
        let showWidth = width-askViewMargin*2
        
        var top: CGFloat = 50
        var left = askViewMargin
        // 大路
        self.bigRoadView = self.askView(left: left, top: top, title: "大路", showWidth: showWidth, titleWidth: roadTitleWidth, cellBgStyle: .solidCircle)
        self.bigRoadView.isShowTxt = false
        // 盘珠路
        top = top+self.itemSize.height*6+askViewMargin
        self.panZhuRoadView = self.askView(left: left, top: top, title: "盘珠路", showWidth: showWidth/2, titleWidth: roadTitleWidth, cellBgStyle: .solidCircle)
        self.panZhuRoadView.isShowTxt = true
        // 大眼路
        left = askViewMargin+showWidth/2
        self.bigEyeRoadView = self.askView(left: left, top: top, title: "大眼路", showWidth: showWidth/2, titleWidth: roadTitleWidth, cellBgStyle: .hollowCircle)
        self.bigEyeRoadView.isShowTxt = false
        // 小路
        top = top+self.itemSize.height*6+askViewMargin
        left = askViewMargin
        self.smallRoadView = self.askView(left: left, top: top, title: "小路", showWidth: showWidth/2, titleWidth: roadTitleWidth, cellBgStyle: .solidCircle)
        self.smallRoadView.isShowTxt = false
        // 曱甴路
        left = askViewMargin+showWidth/2
        self.yueYouRoadView = self.askView(left: left, top: top, title: "曱甴路", showWidth: showWidth/2, titleWidth: roadTitleWidth, cellBgStyle: .solidLine)
        self.yueYouRoadView.isShowTxt = false
        
        
    }
    func askView(left: CGFloat,top: CGFloat,title:String,showWidth:CGFloat,titleWidth:CGFloat,cellBgStyle: LFRoadChartCollectionViewCellBgStyle) -> LFRoadChartView {
        let height: CGFloat = self.itemSize.height*CGFloat(6)
        let bgView = UIView(frame: CGRect(x: left, y: top, width: showWidth, height: height))
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        self.roadContainerView.addSubview(bgView)
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: titleWidth, height: height))
        titleLbl.textAlignment = .center
        titleLbl.backgroundColor = UIColor.lightGray
        titleLbl.textColor = UIColor.white
        titleLbl.font = UIFont.systemFont(ofSize: 14)
        titleLbl.numberOfLines = 0
        bgView.addSubview(titleLbl)
        var showTxt = ""
        for i in 0..<title.count {
            if i == 0 {
                showTxt = ""+title.prefix(i+1)
            }else {
                var subTitle = title.prefix(i+1)
                subTitle = subTitle.suffix(1)
                showTxt = showTxt+"\r\n"+subTitle
            }
            
        }
        titleLbl.text = showTxt
        
        let askView = LFRoadChartView.initView(frame: CGRect(x: titleWidth, y: 0, width: showWidth-titleWidth, height: height))
        askView.itemSize = self.itemSize
        askView.backgroundColor = UIColor.orange
        askView.cellBgStyle = cellBgStyle
        askView.isShowTxt = true
        bgView.addSubview(askView)
        return askView
    }
    func setupItems() -> Void {
        if self.categoryList.count <= self.selectCategeryIndex {
            return
        }
        let oldBtns = self.itemScrollView.subviews
        for oldBtn in oldBtns {
            if oldBtn.isKind(of: UIButton.classForCoder()) {
                oldBtn.removeFromSuperview()
            }
        }
        let categoryModel = self.categoryList[self.selectCategeryIndex]
        var totalWidth: CGFloat = 0
        let btnHeight: CGFloat = 30
        let btnY: CGFloat = (self.itemScrollView.lf_height-btnHeight)/2
        for i in 0..<categoryModel.itemList.count {
            let itemModel = categoryModel.itemList[i]
            let title = itemModel.title!
            let font = UIFont.systemFont(ofSize: 13)
            let btnWidth: CGFloat = LFDrawTool.lf_txtWidth(txt: title, font: font, height: btnHeight)+20
            let btnFrame = CGRect(x: totalWidth, y: btnY, width: btnWidth, height: btnHeight)
            totalWidth = totalWidth + btnWidth + 10
            let btn = self.btn(withTitle: title, frame: btnFrame, selectColor: UIColor.red, normalColor: UIColor.blue, font: font)
            btn.addTarget(self, action: #selector(itemBtnCliked(btn:)), for:.touchUpInside)
            btn.tag = i
            self.itemScrollView.addSubview(btn)
        }
        self.itemScrollView.contentSize = CGSize(width: totalWidth, height: self.itemScrollView.lf_height)
    }
    
    func btn(withTitle title: String,frame: CGRect,selectColor: UIColor,normalColor:UIColor,font: UIFont) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = font
        btn.frame = frame
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.setTitle(title, for: .normal)
        btn.setBackgroundImage(selectColor.lf_colorImage()!, for: .selected)
        btn.setBackgroundImage(normalColor.lf_colorImage()!, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }
    // MARK: - actions
    @objc func closeBtnClicked() -> Void {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func itemBtnCliked(btn:UIButton?) -> Void {
        var sender: UIButton? = btn
        let btnlist = self.itemScrollView.subviews;
        if (btn == nil) {
            // 没有时，表示刚进入时
            for btn1 in btnlist {
                if btn1.isKind(of: UIButton.classForCoder()){
                    if(btn1.tag == self.selectItemIndex){
                        sender = btn1 as? UIButton
                    }else{
                        (btn1 as! UIButton).isSelected = false
                    }
                }
            }
        }else{
            for btn2 in btnlist {
                if btn2.isKind(of: UIButton.classForCoder()){
                    if(btn2 != sender){
                        (btn2 as! UIButton).isSelected = false
                    }
                }
            }
        }
        
        
        sender?.isSelected = true
        self.selectItemIndex = sender!.tag
        let categoryModel = self.categoryList[self.selectCategeryIndex]
        let itemModel = categoryModel.itemList[self.selectItemIndex];
        self.selectItemModel = itemModel;
        
//        // 判断是否显示下三路图
//
//        if(itemModel.isShowBottomThreeRoad){
//            // 要显示下三路
//            self.bottomAskContainerView.hidden = NO;
//            self.bigEyeRoadView.hidden = NO;
//            self.smallRoadView.hidden = NO;
//            self.yueYouRoadView.hidden = NO;
//            // 修改文字
//
//            [self.leftAskView stopDarkAnim];
//            [self.leftAskView stopColorAnim];
//            self.leftAskView.title = [NSString stringWithFormat:@"%@问路",itemModel.askTitles.firstObject];
//            [self.rightAskView stopDarkAnim];
//            [self.rightAskView stopColorAnim];
//            self.rightAskView.title = [NSString stringWithFormat:@"%@问路",itemModel.askTitles.lastObject];
//            // 计算下三路应该出现的颜色
//            // 计算下三路
//            if (self.queue2) {
//                [self.queue2 cancelAllOperations];
//                self.queue2 = nil;
//            }
//            self.queue2 = [[NSOperationQueue alloc] init];
//            // 左侧问路
//            NSArray *inputList1 = [self asendingInputListWithAskTxt:self.selectItemModel.askTitles.firstObject isAddAskModel:YES];
//            WS(weakSelf)
//            [self.queue2 addOperation:[AskRoadCalculateTools calculteBottomThreeOriginSourceWithInputList:inputList1 heType:BigRoadHeCalculateTypeCombine Block:^(NSArray<NSArray<AskRoadOutputModel *> *> *bigEyeRoadList, NSArray<NSArray<AskRoadOutputModel *> *> *smallRoadList, NSArray<NSArray<AskRoadOutputModel *> *> *yueYouRoadList) {
//            if(weakSelf == nil){
//            return ;
//            }
//            SS(strongSelf)
//            AskRoadOutputModel *bigEyeModel = bigEyeRoadList.lastObject.lastObject;
//            AskRoadOutputModel *smallModel = smallRoadList.lastObject.lastObject;
//            AskRoadOutputModel *yueYouModel = yueYouRoadList.lastObject.lastObject;
//            [strongSelf.leftAskView updateAskColors:@[[strongSelf bottomThreeColorWithTxt:bigEyeModel.showTxt],[strongSelf bottomThreeColorWithTxt:smallModel.showTxt],[strongSelf bottomThreeColorWithTxt:yueYouModel.showTxt]]];
//            }]];
//            // 右侧问路
//            NSArray *inputList2 = [self asendingInputListWithAskTxt:self.selectItemModel.askTitles.lastObject isAddAskModel:YES];
//            [self.queue2 addOperation:[AskRoadCalculateTools calculteBottomThreeOriginSourceWithInputList:inputList2 heType:BigRoadHeCalculateTypeCombine Block:^(NSArray<NSArray<AskRoadOutputModel *> *> *bigEyeRoadList, NSArray<NSArray<AskRoadOutputModel *> *> *smallRoadList, NSArray<NSArray<AskRoadOutputModel *> *> *yueYouRoadList) {
//            if(weakSelf == nil){
//            return ;
//            }
//            SS(strongSelf)
//            AskRoadOutputModel *bigEyeModel = bigEyeRoadList.lastObject.lastObject;
//            AskRoadOutputModel *smallModel = smallRoadList.lastObject.lastObject;
//            AskRoadOutputModel *yueYouModel = yueYouRoadList.lastObject.lastObject;
//            [strongSelf.rightAskView updateAskColors:@[[strongSelf bottomThreeColorWithTxt:bigEyeModel.showTxt],[strongSelf bottomThreeColorWithTxt:smallModel.showTxt],[strongSelf bottomThreeColorWithTxt:yueYouModel.showTxt]]];
//            }]];
//        }else{
//            // 不显示下三路
//            self.bottomAskContainerView.hidden = YES;
//            self.bigEyeRoadView.hidden = YES;
//            self.smallRoadView.hidden = YES;
//            self.yueYouRoadView.hidden = YES;
//
//            [self.leftAskView stopDarkAnim];
//            [self.leftAskView stopColorAnim];
//            [self.rightAskView stopDarkAnim];
//            [self.rightAskView stopColorAnim];
//
//            if (self.queue2) {
//                [self.queue2 cancelAllOperations];
//                self.queue2 = nil;
//            }
//
//        }
//        self.bigRoadView.isShowTxt = itemModel.isShowBigRoadTxt;
//        // 重新计算并显示
//        [self calculateAllDataWithAskTxt:nil];
    }
    func parseInputList(askTxt: String?) -> [LFRoadInputParamModel] {
//        NSArray *ascendingList = [[self.dataList reverseObjectEnumerator] allObjects];
//        // 第一球，大小|单双
//        NSArray *inputList = [ascendingList trend_map:^id(NSDictionary *obj) {
//            AskRoadInputModel *model = [AskRoadInputModel new];
//            model.originData = obj;
//            if(self.selectItemModel.tranformBlock){
//            self.selectItemModel.tranformBlock(model, obj);
//            }
//            return model;
//            }];
//        NSMutableArray *inputArrayM = (NSMutableArray *)inputList;
//        if(![inputArrayM isKindOfClass:[NSMutableArray class]]){
//            inputArrayM = [NSMutableArray arrayWithArray:inputList];
//        }
//        if(isAddAskModel && askTxt != nil){
//            AskRoadInputModel *askModel = [AskRoadInputModel new];
//            askModel.beforeTransformTxt = @"?";
//            askModel.afterTransformTxt = askTxt;
//            askModel.isAskRoad = YES;
//            [inputArrayM addObject:askModel];
//        }
//        return inputArrayM;
        let inputList: [LFRoadInputParamModel] = []
        return inputList
    }
    func calculateAllData(askTxt: String?) -> Void {
//        NSArray *inputList = [self asendingInputListWithAskTxt:askTxt isAddAskModel:self.isShowAskRoad];
//        self.bigRoadView.isShowingAskRoad = self.isShowAskRoad;
//        self.zhuPanRoadView.isShowingAskRoad = self.isShowAskRoad;
//        self.bigEyeRoadView.isShowingAskRoad = self.isShowAskRoad;
//        self.smallRoadView.isShowingAskRoad = self.isShowAskRoad;
//        self.yueYouRoadView.isShowingAskRoad = self.isShowAskRoad;
//
//        if(self.queue){
//            [self.queue cancelAllOperations];
//            self.queue = nil;
//        }
//        self.queue = [[NSOperationQueue alloc] init];
//        WS(weakSelf)
//        // 计算大路
//        [self.queue addOperation:[AskRoadCalculateTools calculteBigRoadShowSourceWithInputList:inputList heType:BigRoadHeCalculateTypeNextRow Block:^(NSArray<NSArray *> *showDataList) {
//        weakSelf.bigRoadView.fillCellBlock = weakSelf.selectItemModel.fillCellBlock;
//        weakSelf.bigRoadView.dataList = showDataList;
//
//        }]];
//
//        // 计算珠盘路
//        [self.queue addOperation:[AskRoadCalculateTools calculateZhupanRoadWithInputList:inputList heType:BigRoadHeCalculateTypeNextRow Block:^(NSArray<NSArray<AskRoadOutputModel *> *> *showDataList) {
//        weakSelf.zhuPanRoadView.fillCellBlock = weakSelf.selectItemModel.fillCellBlock;
//        weakSelf.zhuPanRoadView.dataList = showDataList;
//        }]];
//        if(self.selectItemModel.isShowBottomThreeRoad){
//            // 计算下三路
//            [self.queue addOperation:[AskRoadCalculateTools calculteBottomThreeShowSourceWithInputList:inputList heType:BigRoadHeCalculateTypeCombine Block:^(NSArray<NSArray<AskRoadOutputModel *> *> *bigEyeRoadList, NSArray<NSArray<AskRoadOutputModel *> *> *smallRoadList, NSArray<NSArray<AskRoadOutputModel *> *> *yueYouRoadList) {
//                if(weakSelf == nil){
//                return ;
//                }
//                SS(strongSelf)
//                strongSelf.bigEyeRoadView.dataList = bigEyeRoadList;
//                strongSelf.smallRoadView.dataList = smallRoadList;
//                strongSelf.yueYouRoadView.dataList = yueYouRoadList;
//                }]];
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
