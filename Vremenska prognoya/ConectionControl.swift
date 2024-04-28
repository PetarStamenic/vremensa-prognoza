//
//  ConectionControl.swift
//  Vremenska prognoya
//
//  Created by Petar on 13/02/2021.
//
//  namenjeno ya kontrolisanje interneta da li smo poveyani na wifi ethernet data ili nismo poveyani uposte

import Foundation
import Network

//koristimo final da nistaa ne bi nasledjivalo od ove klase

final class ConectionControler {
    
    public private(set) var conectionType : ConectionType = .offline
    //enumeracija jer imamo 4 razlicita stanja konekcije
    enum ConectionType {
        case wifi
        case celullar
        case ethernet
        case offline
            
    }
    
    static let shared = ConectionControler()
    
    //postavljamo proveravanje konekcije na background thred
    private let ConectionQueue = DispatchQueue.global(qos: .userInteractive)
    private let ConectionMonitor : NWPathMonitor
    
    //svi mogu da citaju ali samo ova klasa moye da setuje vrednost
    public private(set) var isOnline : Bool = false
    
    private init () {
        ConectionMonitor = NWPathMonitor()
    }
    
    public func StartConectionCheck() {
        ConectionMonitor.start(queue: ConectionQueue)
        //weak self da iybegnemo yadrzavanja ciklusa da optimiyujemo koriscenje memorije
        ConectionMonitor.pathUpdateHandler = { [weak self] path in
            self?.isOnline = path.status != .unsatisfied
            self?.CheckType(path)
        }
        
        
    }
    
    public func StopConectionCheck() {
        ConectionMonitor.cancel()
    }
    
    //MARK: vrsta konekcije
    private func CheckType(_ path:NWPath) {
        if path.usesInterfaceType(.wifi){
            conectionType = .wifi
        } else if path.usesInterfaceType(.cellular){
            conectionType = .celullar
        } else if path.usesInterfaceType(.wiredEthernet){
            conectionType = .ethernet
        } else {
            conectionType = .offline
        }
    }
    
    
}


