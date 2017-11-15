//
//  AlbumImageCollectionViewController.swift
//  PhotoPicker
//
//  Created by solar on 17/4/25.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit
import Photos
//import SQLite

// 图片缩略图集合页控制器
class AlbumImageCollectionViewController: UIViewController {
    // 用于显示所有图片缩略图的collectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 下方工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    
    // 取得的资源结果，用了存放的PHAsset
    var assetsFetchResults: PHFetchResult<PHAsset>!
    
    // 带缓存的图片管理对象
    var imageManager: PHCachingImageManager!
    
    // 缩略图大小
    var assetGridThumbnailSize: CGSize!
    
    // 每次最多可选择的照片数量
    var maxSelected: Int = Int.max
    
    // 照片选择完毕后的回调
    var completeHandler: ((_ assets: [PHAsset])->())?
    
    // 完成按钮
    var completeButton: AlbumImageCompleteButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 根据单元格的尺寸计算我们需要的缩略图大小
        let scale = UIScreen.main.scale
        let cellSize = (self.collectionView.collectionViewLayout as!
            UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // 背景色设置为白色（默认是黑色）
        self.collectionView.backgroundColor = UIColor.white
        
        // 初始化和重置缓存
        self.imageManager = PHCachingImageManager()
        self.resetCachedAssets()
        
        // 设置单元格尺寸
        let layout = (self.collectionView.collectionViewLayout as!
            UICollectionViewFlowLayout)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4,
                                 height: UIScreen.main.bounds.width / 4)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        // 允许多选
        self.collectionView.allowsMultipleSelection = false
        
        // 添加导航栏右侧的取消按钮
        let rightBarItem = UIBarButtonItem(title: "取消", style: .plain,
                                           target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        //不透明化导航栏
        self.navigationController?.navigationBar.isTranslucent = false
        
        // 添加下方工具栏的完成按钮
        completeButton = AlbumImageCompleteButton()
        completeButton.addTarget(target: self, action: #selector(finishSelect))
        completeButton.center = CGPoint(x: UIScreen.main.bounds.width - 50, y: 22)
        completeButton.isEnabled = false
        toolBar.addSubview(completeButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //透明化导航栏
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // 重置缓存
    func resetCachedAssets() {
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    // 取消按钮点击
    @objc func cancel() {
        // 退出当前视图控制器
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    // 获取已选择个数
    func selectedCount() -> Int {
        return self.collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    // 完成按钮点击
    @objc func finishSelect(){
        // 取出已选择的图片资源
        var assets:[PHAsset] = []
        if let indexPaths = self.collectionView.indexPathsForSelectedItems{
            for indexPath in indexPaths{
        assets.append(assetsFetchResults[indexPath.row] )
            }
        }
        
        //当选择的类型是图片
        let img = PHAssetToUIImage(asset: assets.first!)
        var imgData = UIImagePNGRepresentation(img)?.base64EncodedString()
        var stmt: OpaquePointer? = nil
//        let id = GameCenterMatch.getLocalPlayerId()
        let id = "G:1997561279"
//        let sentence = "INSERT INTO avatarTable(gameCenterId, avatar) VALUES(?,?);"
//        let sentence = "INSERT INTO user(userId, userName, password, email) VALUES(?,?,?,?);"
        let sentence = "INSERT INTO avatarTable(gameCenterId) VALUES('\(id)');"

        
//        sqlite3_bind_text(stmt, 2, imgData?.cString(using: .utf8), -1, nil)
        sqlite3_bind_text(stmt, 1, id.cString(using: .utf8), -1, nil)
        
        //        sqlite3_bind_int(stmt, 1, Int32(16))
//        sqlite3_bind_text(stmt, 2, "南燕".cString(using: .utf8), -1, nil)
//        sqlite3_bind_text(stmt, 3, "029301".cString(using: .utf8), -1, nil)
//        sqlite3_bind_text(stmt, 4, "16@16".cString(using: .utf8), -1, nil)
        
        let sql = sentence.cString(using: .utf8)
        
        let prepare_result = sqlite3_prepare_v2(singleViewController.db, sql!, -1, &stmt, nil)

        //判断如果失败，获取失败信息
        if prepare_result != SQLITE_OK {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(singleViewController.db)) != nil {
                let msg = "SQLiteDB - failed to prepare SQL:\(sentence)"
                print(msg)
                return
            }
        }
        
        //step执行
        let step_result = sqlite3_step(stmt)

        //判断执行结果，如果失败，获取失败信息
        if step_result != SQLITE_OK && step_result != SQLITE_DONE {
            sqlite3_finalize(stmt)
            if (sqlite3_errmsg(singleViewController.db)) != nil {
                let msg = "SQLiteDB - failed to execute SQL:\(sentence)"
                print(msg)
                return
            }
        }
//        let execResult = sqlite3_exec(singleViewController.db, sql, nil, nil, nil)
//        if execResult != SQLITE_OK{
//            print(execResult)
//            return
//        }
        
        //finalize
        sqlite3_finalize(stmt)
        
        // 调用回调函数
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
// 图片缩略图集合页控制器UICollectionViewDataSource,UICollectionViewDelegate协议方法的实现
extension AlbumImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // CollectionView项目
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults.count
    }
    
    // 获取单元格
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 获取storyboard里设计的单元格，不需要再动态添加界面元素
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumImageCollectionViewCell
        let asset = self.assetsFetchResults[indexPath.row]
        // 获取缩略图
        self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize, contentMode: .aspectFill, options: nil) {
            (image, _) in
            cell.imageView.image = image
        }
        return cell
    }
    
    // 单元格选中响应
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AlbumImageCollectionViewCell {
            // 获取选中的数量
            let count = self.selectedCount()
            // 如果选择的个数大于最大选择数
            if count > self.maxSelected {
                // 设置为不选中状态
                collectionView.deselectItem(at: indexPath, animated: false)
                // 弹出提示
                let title = "你最多只能选择\(self.maxSelected)张照片"
                let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title:"我知道了", style: .cancel, handler:nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            // 如果不超过最大选择数
            else{
                // 改变完成按钮数字，并播放动画
                completeButton.num = count
                if count > 0 && !self.completeButton.isEnabled{
                    completeButton.isEnabled = true
                }
                cell.playAnimate()
            }
        }
    }
    
    // 单元格取消选中响应
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AlbumImageCollectionViewCell {
            // 获取选中的数量
            let count = self.selectedCount()
            completeButton.num = count
            // 改变完成按钮数字，并播放动画
            if count == 0{
                completeButton.isEnabled = false
            }
            cell.playAnimate()
        }
    }
    
    func PHAssetToUIImage(asset: PHAsset) -> UIImage {
        var image = UIImage()
        
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .opportunistic
        let size = CGSize(width: 50, height: 50)
        // 按照PHImageRequestOptions指定的规则取出图片
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
    }
}
