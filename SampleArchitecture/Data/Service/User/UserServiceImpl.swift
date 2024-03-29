//
// Created by user on 08.11.2019.
// Copyright (c) 2019 user. All rights reserved.
//

import Foundation
import RxSwift

class UserServiceImpl: UserService {

    let realmRepo: UserRepository
    let remoteRepo: UserRepository

    init(realmRepo: UserRepository, remoteRepo: UserRepository) {
        self.realmRepo = realmRepo
        self.remoteRepo = remoteRepo
    }

    func refreshUserData() -> Observable<[UserData]> {
        remoteRepo.getUserDataList()
                .flatMap { users in
                    self.saveUsers(users: users)
                            .andThen(self.realmRepo.getUserDataList())
                }
    }

    func getUserDataList() -> Observable<[UserData]> {
        realmRepo.getUserDataList()
    }

    func getUserData(dataId: Int) -> Observable<UserData> {
        realmRepo.getUserData(dataId: dataId)
    }

    func setDataCompleted(dataId: Int, completed: Bool) -> Observable<UserData> {
        realmRepo.setDataCompleted(dataId: dataId, completed: completed)
    }

    func removeData(dataId: Int) -> Completable {
        realmRepo.removeData(dataId: dataId)
    }

    private func saveUsers(users: [UserData]) -> Completable {
        realmRepo.saveUserData(users: users)
    }
}
