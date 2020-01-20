//
//  PostRepository.swift
//  ArchitectureSample01
//
//  Created by Naoki Kameyama on 2020/01/13.
//  Copyright © 2020 Naoki Kameyama. All rights reserved.
//

import Foundation
import RxSwift

protocol PostRepository {
    func create(with content: String) -> Observable<Void>
    func read() -> Observable<[Post]>
    func update(_ post: Post) -> Observable<Void>
    func delete(_ postId: String) -> Observable<Void>
}
