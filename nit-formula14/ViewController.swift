//
//  ViewController.swift
//  bleSample_2からの引用s
//
//  Created by 澤田昂明 on 2016/03/03.
//  Copyright © 2016年 Takarki. All rights reserved.
//

import CoreBluetooth
import UIKit

class ViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    @IBOutlet var label:UILabel!
    
    let cbserviceUUID = "BD011F22-7D3C-0DB6-E441-55873D44EF40"
    let charactaUUID = "2A750D7D-BD9A-928F-B744-7D5A70CEF1F9"
    
    var centralManager:CBCentralManager!
    //ペリフェラルのプロパティ宣言
    var peripheral:CBPeripheral!
    
    @IBOutlet var stateLabel:UILabel!
    //画像のプロパティの宣言
    @IBOutlet var imageView1:UIImageView!
    @IBOutlet var imageView2:UIImageView!
    @IBOutlet var imageView3:UIImageView!
    @IBOutlet var imageView4:UIImageView!
    @IBOutlet var imageView5:UIImageView!
    @IBOutlet var imageView6:UIImageView!
    @IBOutlet var imageView7:UIImageView!
    @IBOutlet var imageView8:UIImageView!
    
    
    @IBOutlet var shiftLabel:UILabel!
    @IBOutlet var byteLabel:UILabel!
    
    
    var timer:NSTimer!
    var count:Int = 0
    
    //BLEに接続時に画像を順に表示させるメソッド
    func cun(){

        
        let imageGreen:UIImage = UIImage(named:"formula_inst_1greenbar.png")!
        let imageYellow:UIImage = UIImage(named:"formula_inst_1yellowbar.png")!
        let imageRed:UIImage = UIImage(named:"formula_inst_1redbar.png")!
        //let base:UIImage = UIImage(named:"iPhone5_baseA")!
        
        switch count{
        case 0:
            self.imageView1.image = imageGreen
            break
        case 1:
            self.imageView2.image = imageGreen
            break
        case 2:
            self.imageView3.image = imageGreen
            break
        case 3:
            self.imageView4.image = imageYellow
            break
        case 4:
            self.imageView5.image = imageYellow
            break
        case 5:
            self.imageView6.image = imageYellow
            break
        case 6:
            self.imageView7.image = imageRed
            break
        case 7:
            self.imageView8.image = imageRed
            break
        case 10:
            self.imageView8.hidden = true
            break
        case 11:
            self.imageView7.hidden = true
            break
        case 12:
            self.imageView6.hidden = true
            break
        case 13:
            self.imageView5.hidden = true
            break
        case 14:
            self.imageView4.hidden = true
            break
        case 15:
            self.imageView3.hidden = true
            break
        case 16:
            self.imageView2.hidden = true
            break
        case 17:
            self.imageView1.hidden = true
            break
        default:
            break
            
            
        }
        
        count=count+1
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("cun"), userInfo: nil, repeats: true)
        
        //cun()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*////////////////////////////////////////////////////////////////////////////////////
     
     MARK:Bluetooth*/
    
    ////////////////////////////////////////////////////////////////////////////////////
    @IBAction func scanstart(){
        
        //cun()
        //CBCentralManagerを初期化する
        centralManager = CBCentralManager(delegate:self,queue: nil, options:nil)
        
        
        
    }
    
    //CBCentralManagerの状態が変化した時に呼ばれるメソッド
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        //var serviceUUIDs: [CBUUID] = [CBUUID.UUIDWithString(kServiceUUID)]
        //self.centralManager.scanForPeripheralsWithServices(serviceUUIDs, options: nil)
        
        print("state \(central.state)");
        switch (central.state) {
        case .PoweredOff:
            print("Bluetoothの電源がOff")
        case .PoweredOn:
            print("Bluetoothの電源はOn")
            // BLEデバイスの検出を開始.
            centralManager.scanForPeripheralsWithServices(nil, options: nil)
        case .Resetting:
            print("レスティング状態")
        case .Unauthorized:
            print("非認証状態")
        case .Unknown:
            print("不明")
        case .Unsupported:
            print("非対応")
        }
    }
    
    
    /*
     BLEデバイスが検出された際に呼び出される.
     */
    func centralManager(central: CBCentralManager,didDiscoverPeripheral peripheral: CBPeripheral,advertisementData: [String:AnyObject],RSSI: NSNumber){
        
        //ここでは欲しいシリアルのペリフェラルだけを取得
        if peripheral.name == "BLESerial2"{
            
//            print("pheripheral.name: \(peripheral.name)")
//            print("advertisementData:\(advertisementData)")
//            print("RSSI: \(RSSI)")
//            print("peripheral.identifier.UUIDString: \(peripheral.identifier.UUIDString)")
            
            var name: NSString? = advertisementData["kCBAdvDataLocalName"] as? NSString
            if (name == nil) {
                name = "no name";
                
            }
            
            self.peripheral = peripheral
            
            //BLEデバイスが検出された時にペリフェラルの接続を開始する
            self.centralManager.connectPeripheral(self.peripheral, options:nil)
        }else{
            stateLabel.text = "未発見"
        }
        
    }
    
    //ペリフェラルの接続が成功すると呼ばれる
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("接続成功!")
        
        /*ペリフェラルの接続が成功時,
         サービス探索結果を受け取るためにデリゲートをセット*/
        peripheral.delegate = self
        
        //サービス探索開始(nilを渡すことで全てのサービスが探索対象になる)
        peripheral.discoverServices(nil)
        print("サービスの探索を開始しました．")
        
        //スキャンを停止させる
        centralManager.stopScan()
        stateLabel.text = "検出中"
    }
    //ペリフェラルの接続が失敗すると呼ばれる
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("接続失敗...")
        stateLabel.text = "失敗"
    }
    
    //サービスが見つかった時に呼ばれるメソッド
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        let services:NSArray = peripheral.services!
        print("\(services.count)個のサービスを発見 \(services)")
        
        for obj in services{
            if let service = obj as? CBService{
                
                //キャラクタリスティックの探索を開始する
                //var characteristicUUID:[CBUUID] = ["2A750D7D-BD9A-928F-B744-7D5A70CEF1F9"]
                peripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }
    
    //キャラクタリスティックが見つかった時に呼ばれるメソッド
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        let characteristics:NSArray = service.characteristics!
        print("\(characteristics.count)個のキャラクタリスティックを発見! \(characteristics)")
        
        
        for obj in characteristics{
            if let characteristic = obj as? CBCharacteristic{
                
                peripheral.readValueForCharacteristic(characteristic)
                print("読み出しを開始")
                
                if characteristic.UUID.isEqual(CBUUID(string:"2A750D7D-BD9A-928F-B744-7D5A70CEF1F9")){
                    //Notifyingを開始
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                }
                
            }
        }
    }
    
    
    //キャラクタリスティックが読み出された時に呼ばれるメソッド
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        //print("読み出し成功! service uuid:\(characteristic.service.UUID), characteristic uuid:\(characteristic.UUID), vallue:\(characteristic.value)")
        
        
        if characteristic.UUID.isEqual(CBUUID(string:"2A750D7D-BD9A-928F-B744-7D5A70CEF1F9")){
            
            //var byte:CUnsignedChar = 0
            var byte:NSInteger = 0
            
            //1バイト取り出す
            characteristic.value?.getBytes(&byte, length: sizeof(NSInteger))
            
            print("byte:\(byte)")
            byteLabel.text = String(byte)
            //            label.text = "\(byte)"
            stateLabel.text = "接続"
            
            
            //            if byte / 10 == 0 {
            //                shiftLabel.text = "N"
            //            }
            
            let rpm:Int = byte / 10000000
            print(rpm)
            rpmAnime(rpm)
            
            let shift:Int = byte / 1000000 - (rpm * 10)
            shiftLabel.text = String(shift)
            if shift == 0{
                print("ニュートラル")
                shiftLabel.text = "N"
            }
            
            let water:Int = byte / 1000 - (shift * 1000) - (rpm * 10000)
            print(water)
            label.text = String(water)
            
        }
    }
    
    //Notifyingが開始された時に呼ばれる
    //状況を伝えるメソッド
    func peripheral(peripheral:CBPeripheral,didUpdateNotificationStateForCharacteristic characteristic:CBCharacteristic,error:NSError?){
        if error != nil{
            print("Notify状態更新失敗...error:\(error)")
            stateLabel.text = "更新不可"
            
        }else{
            print("Notify状態更新成功! isNotifying:\(characteristic.isNotifying)")
            
            if characteristic.UUID.isEqual(CBUUID(string:"2A750D7D-BD9A-928F-B744-7D5A70CEF1F9")){
                
                stateLabel.text = "更新中"
                //var byte:CUnsignedChar = 0
                var byte:NSInteger = 0
                
                //1バイト取り出す
                characteristic.value?.getBytes(&byte, length: sizeof(NSInteger))
                
                print("byte:\(byte)")
                
                //rpmを抽出
                let rpm:Int = byte / 10000000
                rpmAnime(rpm)
                
                //シフトレベルを抽出して表示
                let shift:Int = byte / 1000000 - (rpm * 10)
                shiftLabel.text = String(shift)
                if shift == 0{
                    shiftLabel.text = "N"
                }
                
                //水温を抽出して表示
                let water:Int = byte / 1000 - (shift * 1000) - (rpm * 10000)
                label.text = String(water)
                
            }
            
            
        }
    }
    
    //RPMの画像貼る
    func rpmAnime(rpm:Int){
        
        let imageGreen:UIImage = UIImage(named:"formula_inst_1greenbar.png")!
        let imageYellow:UIImage = UIImage(named:"formula_inst_1yellowbar.png")!
        let imageRed:UIImage = UIImage(named:"formula_inst_1redbar.png")!
        
        switch rpm{
        case 1:
            imageView1.image = imageGreen
            break
        case 2:
            imageView1.image = imageGreen
            imageView2.image = imageGreen
            break
        case 3:
            imageView1.image = imageGreen
            imageView2.image = imageGreen
            imageView3.image = imageGreen
            break
        case 4:
            imageView1.image = imageGreen
            imageView2.image = imageGreen
            imageView3.image = imageGreen
            imageView4.image = imageYellow
            break
        case 5:
            imageView1.image = imageGreen
            imageView2.image = imageGreen
            imageView3.image = imageGreen
            imageView4.image = imageYellow
            imageView5.image = imageYellow
            break
        case 6:
            imageView1.image = imageGreen
            imageView2.image = imageGreen
            imageView3.image = imageGreen
            imageView4.image = imageYellow
            imageView5.image = imageYellow
            imageView6.image = imageYellow
            break
        case 7:
            imageView1.image = imageGreen
            imageView2.image = imageGreen
            imageView3.image = imageGreen
            imageView4.image = imageYellow
            imageView5.image = imageYellow
            imageView6.image = imageYellow
            imageView7.image = imageRed
            break
        case 8,9:
            imageView1.image = imageGreen
            imageView2.image = imageGreen
            imageView3.image = imageGreen
            imageView4.image = imageYellow
            imageView5.image = imageYellow
            imageView6.image = imageYellow
            imageView7.image = imageRed
            imageView8.image = imageRed
            break
        default:
            break
        }
    }
    
    
    
    
    
    
}

