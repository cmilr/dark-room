//
//  Result.swift
//  Result
//
//  Created by Cary Miller on 6/1/18.
//  Copyright © 2018 C.Miller & Co. All rights reserved.
//

import Foundation

public enum Result<Value> {
   case success(Value)
   case failure(Error)

   public var value: Value? {
      switch self {
      case .success(let v): return v
      case .failure: return nil
      }
   }

   public var error: Error? {
      switch self {
      case .success: return nil
      case .failure(let e): return e
      }
   }

   public var isError: Bool {
      switch self {
      case .success: return false
      case .failure: return true
      }
   }
}
