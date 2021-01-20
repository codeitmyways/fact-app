//
//  HomeViewModel.swift
//  Fact-App
//
//  Created by Sumit meena on 20/01/21.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel{
    public let facts : PublishSubject <[Fact]> = PublishSubject()
    public let title : PublishSubject <String> = PublishSubject()
    public let loading : PublishSubject <Bool> = PublishSubject()
    public let error : PublishSubject <String> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    // MARK: - API Calling
    public func getFacts(){
        loading.onNext(true)
        APIRequestFact().dispatch { (response) in
            self.loading.onNext(false)
            self.facts.onNext(response.rows)
            self.title.onNext(response.title)
        } onFailure: { (errorResponse, error) in
            if let errorMsg  = (errorResponse?.message ?? error.localizedDescription) {
//                self.error.onNext(errorMsg)
                print(errorMsg)
            }
        }
    }


}
