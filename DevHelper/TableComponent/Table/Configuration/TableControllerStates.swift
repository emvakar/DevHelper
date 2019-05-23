//
//  TableControllerStates.swift
//  DevHelper
//
//  Created by Emil Karimov on 17.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: - Data states
public enum TableContentState {
    case success                    //Успешно загрузилось
    case noContent                  //пришел пустой список
    case failedLoaded               //Ошибка загрузки
    case failedNextPageLoaded       //ошибка загрузки след. страницы
    case endFetching                //Конец постраничной загрузки
}

// MARK: - Process state
public enum TableProcessState {
    case loading                    //Процесс загрузки
    case stopped                    //Нет никаких процессов
}
