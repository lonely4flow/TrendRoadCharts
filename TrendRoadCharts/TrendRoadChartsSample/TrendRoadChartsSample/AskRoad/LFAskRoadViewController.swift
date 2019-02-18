//
//  LFAskRoadViewController.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//
//主色调
let kBgLightBlueColor = kRGBColor(R: 67, G: 85, B: 103)
let kBgLightGrayColor = kRGBColor(R: 246, G: 248, B: 250)
// 操作按钮颜色
let kBtnSelectColor = kRGBColor(R: 63, G: 95, B: 190)
let kBtnNormalColor = kRGBColor(R: 54, G: 65, B: 77)
// 问路图中的红、蓝、绿三色
let kRoadRedColor = kRGBColor(R: 218, G: 123, B: 120)
let kRoadBlueColor = kRGBColor(R: 88, G: 138, B: 230)
let kRoadGreenColor = kRGBColor(R: 154, G: 219, B: 116)

import UIKit
typealias LFRoadTransformInputModelClosure = (_ inputModel:LFRoadInputParamModel,_ obj: AnyObject)->Void

class LFAskRoadViewController: UIViewController {

    var showQueue: OperationQueue?
    var askQueue: OperationQueue?
    
    var roadContainerView: UIView!
    
    var itemScrollView: UIScrollView!
    
    var itemSize: CGSize = CGSize(width: 20, height: 20)
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
    var dataList: [[String:AnyObject]] = []
    var isShowingAskRoad: Bool = false
    
    var categoryBtn: UIButton!
    var bigRoadHeCalculateType: LFRoadCalculateHeType = .nextRow
    var calculateTypeBtn: UIButton?
    var typeList: [[String:Any]] = [
        ["title":"和另一行","type":LFRoadCalculateHeType.nextRow,"color":UIColor.brown],
    ["title":"和另一列","type":LFRoadCalculateHeType.nextCol,"color":UIColor.blue],
    ["title":"和合并一格","type":LFRoadCalculateHeType.combine,"color":UIColor.purple]]
    var bigRoadHeCountStyle: LFRoadChartCollectionViewCellHeCountShowStyle = .line
    var combineBtn: UIButton?
    var combineList: [[String:Any]] = [
        ["title":"斜线/","type":LFRoadChartCollectionViewCellHeCountShowStyle.line,"color":UIColor.red],
        ["title":"数字","type":LFRoadChartCollectionViewCellHeCountShowStyle.numTxt,"color":UIColor.orange],
        ["title":"不显示","type":LFRoadChartCollectionViewCellHeCountShowStyle.none,"color":UIColor.green]]
    
    // MARK: - UI
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareDataList()
        self.setupUI()
        self.itemBtnCliked(btn: nil)
        
    }
    
    /// 子类实现创建数据
    func prepareDataList() -> Void
    {
        
    }
    func setupUI() -> Void {
        let width: CGFloat = UIScreen.main.lf_width
        let closeBtnWidth: CGFloat = 60
        let rightMargin: CGFloat = 20
        
        self.calculateTypeBtn = self.btn(withTitle: self.typeList.first!["title"] as! String, frame: CGRect(x: 20, y: 20, width: 100, height: 40))
        self.calculateTypeBtn!.isSelected = true
        self.calculateTypeBtn!.addTarget(self, action: #selector(changeBigRoadCalculateType(btn:)), for: .touchUpInside)
        self.view.addSubview(self.calculateTypeBtn!)
        
        self.combineBtn = self.btn(withTitle: self.combineList.first!["title"] as! String, frame: CGRect(x: 130, y: 20, width: 80, height: 40))
        self.combineBtn!.isSelected = true
        self.combineBtn?.isHidden = true
        self.combineBtn!.addTarget(self, action: #selector(changeCombineType(btn:)), for: .touchUpInside)
        self.view.addSubview(self.combineBtn!)
       
        
        // 关闭按钮
        let closeBtn = self.btn(withTitle: "关闭", frame: CGRect(x: width - closeBtnWidth-rightMargin, y: rightMargin, width: closeBtnWidth, height: 40))
        closeBtn.setBackgroundImage(kBtnNormalColor.lf_colorImage(), for: .normal)
        closeBtn.setBackgroundImage(kBtnSelectColor.lf_colorImage(), for: .selected)
        closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        self.view.addSubview(closeBtn)
        
        self.roadContainerView = UIView(frame: CGRect(x: 0, y: 120, width: width, height: 600))
        self.roadContainerView.backgroundColor = kBgLightBlueColor
        self.view.addSubview(self.roadContainerView)
        
        
        let itemBgView = UIView(frame: CGRect(x: 0, y: 5, width: width, height: 40))
        itemBgView.backgroundColor = kBgLightGrayColor
        self.roadContainerView.addSubview(itemBgView);
        
        self.categoryBtn = self.btn(withTitle: self.categoryList.first!.title!, frame: CGRect(x: 10, y: 0, width: 80, height: 30))
        self.categoryBtn!.isSelected = true
        self.categoryBtn!.addTarget(self, action: #selector(categoryBtnClicked(btn:)), for: .touchUpInside)
        self.roadContainerView.addSubview(self.categoryBtn!)
        
        self.itemScrollView = UIScrollView(frame: CGRect(x: 100, y: 0, width: width-100, height: 40))
        self.itemScrollView.backgroundColor = kBgLightGrayColor
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
        
        // 底部问路区域
        
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
        askView.backgroundColor = self.roadContainerView.backgroundColor
        askView.cellBgStyle = cellBgStyle
        askView.isShowTxt = true
        askView.fillCellClosure = {(outputModel: LFRoadOutputParamModel, cell: LFRoadChartCollectionViewCell) in
            if "红" == outputModel.showTxt {
                cell.bgColor = kRoadRedColor
            }else{
                cell.bgColor = kRoadBlueColor
            }
        }
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
            let btn = self.btn(withTitle: title, frame: btnFrame, selectColor: kBtnSelectColor, normalColor: kBtnNormalColor, font: font)
            btn.addTarget(self, action: #selector(itemBtnCliked(btn:)), for:.touchUpInside)
            btn.tag = i
            self.itemScrollView.addSubview(btn)
        }
        self.itemScrollView.contentSize = CGSize(width: totalWidth, height: self.itemScrollView.lf_height)
    }
    
    func btn(withTitle title: String,frame: CGRect,selectColor:UIColor = kBtnSelectColor, normalColor:UIColor = kBtnNormalColor, font:UIFont = UIFont.systemFont(ofSize: 14)) -> UIButton {
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
    @objc func changeBigRoadCalculateType(btn: UIButton) -> Void
    {
  
        //configure cell
        var configures:[DropCellConfigure] = []
        for i in 0 ..< self.typeList.count{
            let dict = self.typeList[i]
            let configure = DropCellConfigure()
            configure.title = dict["title"] as! String
            configure.cellBackGroundColor = dict["color"] as! UIColor
            configures.append(configure)
        }
        
        //show listView and wait for callBack
        DropListView.showDropListViewWithRelateView(self.calculateTypeBtn!, showingItems: configures, cellAlignment: .left, cellSeletCallBack: { (index) in
            let dict = self.typeList[index]
            self.calculateTypeBtn?.setTitle(dict["title"] as? String, for: .normal)
            self.bigRoadHeCalculateType = dict["type"] as! LFRoadCalculateHeType
            if LFRoadCalculateHeType.combine == self.bigRoadHeCalculateType {
                self.bigRoadView.cellBgStyle = .hollowCircle
                self.combineBtn?.isHidden = false
            }else{
                self.bigRoadView.cellBgStyle = .solidCircle
                self.combineBtn?.isHidden = true
            }
            self.bigRoadView.cellHeCountShowStyle = self.bigRoadHeCountStyle
            self.calculateAllData(askTxt: nil)
        }, userDismissDropViewCallBack: {
            print("user cancel")
        })
    }
    @objc func changeCombineType(btn:UIButton) -> Void
    {
        //configure cell
        var configures:[DropCellConfigure] = []
        for i in 0 ..< self.combineList.count{
            let dict = self.combineList[i]
            let configure = DropCellConfigure()
            configure.title = dict["title"] as! String
            configure.cellBackGroundColor = dict["color"] as! UIColor
            configures.append(configure)
        }
        
        //show listView and wait for callBack
        DropListView.showDropListViewWithRelateView(self.combineBtn!, showingItems: configures, cellAlignment: .left, cellSeletCallBack: { (index) in
            let dict = self.combineList[index]
            self.combineBtn?.setTitle(dict["title"] as? String, for: .normal)
             self.bigRoadHeCountStyle = dict["type"] as! LFRoadChartCollectionViewCellHeCountShowStyle
            self.bigRoadView.cellHeCountShowStyle = self.bigRoadHeCountStyle
            self.calculateAllData(askTxt: nil)
        }, userDismissDropViewCallBack: {
            print("user cancel")
        })
    }
    @objc func categoryBtnClicked(btn: UIButton) -> Void
    {
        //configure cell
        var configures:[DropCellConfigure] = []
        for i in 0 ..< self.categoryList.count{
            let categoryModel = self.categoryList[i]
            let configure = DropCellConfigure()
            configure.title = categoryModel.title!
            configures.append(configure)
        }
        
        //show listView and wait for callBack
        DropListView.showDropListViewWithRelateView(self.categoryBtn!, showingItems: configures, cellAlignment: .left, cellSeletCallBack: { (index) in
            let categoryModel = self.categoryList[index]
            self.categoryBtn?.setTitle(categoryModel.title!, for: .normal)
            self.selectCategeryIndex = index
            self.selectItemIndex = 0
            self.setupItems()
            self.itemBtnCliked(btn: nil)
            
        }, userDismissDropViewCallBack: {
            print("user cancel")
        })
    }
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
        
        if sender?.isSelected ?? false {
            return
        }
        sender?.isSelected = true
        self.selectItemIndex = sender!.tag
        let categoryModel = self.categoryList[self.selectCategeryIndex]
        let itemModel = categoryModel.itemList[self.selectItemIndex];
        self.selectItemModel = itemModel;
        
        self.bigRoadView.isShowTxt = self.selectItemModel?.isShowBigRoadTxt ?? false
        self.bigEyeRoadView.isHidden = !self.selectItemModel!.isShowBottomThreeRoad
        self.smallRoadView.isHidden = !self.selectItemModel!.isShowBottomThreeRoad
        self.yueYouRoadView.isHidden = !self.selectItemModel!.isShowBottomThreeRoad
        
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
        // 重新计算并显示
        self.calculateAllData(askTxt: nil)
    }
    func parseInputList(askTxt: String?) -> [LFRoadInputParamModel] {
//        NSArray *ascendingList = [[self.dataList reverseObjectEnumerator] allObjects];
        var inputList: [LFRoadInputParamModel] = self.dataList.map { (obj:[String:AnyObject]) -> LFRoadInputParamModel in
            let inputModel = LFRoadInputParamModel()
            inputModel.originData = obj
            self.selectItemModel?.transformClosure?(inputModel,obj as AnyObject)
            return inputModel
        }
        // 添加问路的一格
        if askTxt != nil {
            let inputModel = LFRoadInputParamModel()
            inputModel.beforeTransformTxt = "?"
            inputModel.afterTransformTxt = askTxt!
            inputList.append(inputModel)
        }
        return inputList
    }
    func calculateAllData(askTxt: String?) -> Void {
        let inputList = self.parseInputList(askTxt: askTxt)
        self.bigRoadView.isShowingAskRoad = self.isShowingAskRoad
        self.panZhuRoadView.isShowingAskRoad = self.isShowingAskRoad
        self.bigEyeRoadView.isShowingAskRoad = self.isShowingAskRoad
        self.smallRoadView.isShowingAskRoad = self.isShowingAskRoad
        self.yueYouRoadView.isShowingAskRoad = self.isShowingAskRoad

        self.showQueue?.cancelAllOperations()
        self.showQueue = nil
        self.showQueue = OperationQueue()
        // 计算大路
    self.showQueue?.addOperation(LFRoadCalculateTool.calculateInputListToBigRoadShowList(inputList: inputList, heType: self.bigRoadHeCalculateType, callback: { (showList: [[AnyObject]]) in
            self.bigRoadView.fillCellClosure = self.selectItemModel?.cellFillClosure
            self.bigRoadView.dataList = showList
        }))
        

        // 计算珠盘路
    self.showQueue?.addOperation(LFRoadCalculateTool.calculateInputListToPanzhuShowList(inputList: inputList, callback: { (showList: [[AnyObject]]) in
            self.panZhuRoadView.fillCellClosure = self.selectItemModel?.cellFillClosure
            self.panZhuRoadView.dataList = showList
        }))
        

        if self.selectItemModel!.isShowBottomThreeRoad {
            // 计算下三路
        self.showQueue?.addOperation(LFRoadCalculateTool.calculateInputListToBottomThreeShowList(inputList: inputList, heType: .combine, callback: { (bigEyeShowList:[[AnyObject]],smallShowList: [[AnyObject]], yueYouShowList:[[AnyObject]]) in
                self.bigEyeRoadView.dataList = bigEyeShowList
                self.smallRoadView.dataList = smallShowList
                self.yueYouRoadView.dataList = yueYouShowList
            }))
        }

    }


}
