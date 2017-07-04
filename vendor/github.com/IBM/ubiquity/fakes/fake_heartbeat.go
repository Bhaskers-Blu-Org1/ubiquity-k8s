/**
 * Copyright 2017 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// This file was generated by counterfeiter
package fakes

import (
	"sync"
	"time"

	"github.com/IBM/ubiquity/utils"
)

type FakeHeartbeat struct {
	ExistsStub        func() (bool, error)
	existsMutex       sync.RWMutex
	existsArgsForCall []struct{}
	existsReturns     struct {
		result1 bool
		result2 error
	}
	existsReturnsOnCall map[int]struct {
		result1 bool
		result2 error
	}
	CreateStub        func() error
	createMutex       sync.RWMutex
	createArgsForCall []struct{}
	createReturns     struct {
		result1 error
	}
	createReturnsOnCall map[int]struct {
		result1 error
	}
	UpdateStub        func() error
	updateMutex       sync.RWMutex
	updateArgsForCall []struct{}
	updateReturns     struct {
		result1 error
	}
	updateReturnsOnCall map[int]struct {
		result1 error
	}
	GetLastUpdateTimestampStub        func() (time.Time, error)
	getLastUpdateTimestampMutex       sync.RWMutex
	getLastUpdateTimestampArgsForCall []struct{}
	getLastUpdateTimestampReturns     struct {
		result1 time.Time
		result2 error
	}
	getLastUpdateTimestampReturnsOnCall map[int]struct {
		result1 time.Time
		result2 error
	}
	invocations      map[string][][]interface{}
	invocationsMutex sync.RWMutex
}

func (fake *FakeHeartbeat) Exists() (bool, error) {
	fake.existsMutex.Lock()
	ret, specificReturn := fake.existsReturnsOnCall[len(fake.existsArgsForCall)]
	fake.existsArgsForCall = append(fake.existsArgsForCall, struct{}{})
	fake.recordInvocation("Exists", []interface{}{})
	fake.existsMutex.Unlock()
	if fake.ExistsStub != nil {
		return fake.ExistsStub()
	}
	if specificReturn {
		return ret.result1, ret.result2
	}
	return fake.existsReturns.result1, fake.existsReturns.result2
}

func (fake *FakeHeartbeat) ExistsCallCount() int {
	fake.existsMutex.RLock()
	defer fake.existsMutex.RUnlock()
	return len(fake.existsArgsForCall)
}

func (fake *FakeHeartbeat) ExistsReturns(result1 bool, result2 error) {
	fake.ExistsStub = nil
	fake.existsReturns = struct {
		result1 bool
		result2 error
	}{result1, result2}
}

func (fake *FakeHeartbeat) ExistsReturnsOnCall(i int, result1 bool, result2 error) {
	fake.ExistsStub = nil
	if fake.existsReturnsOnCall == nil {
		fake.existsReturnsOnCall = make(map[int]struct {
			result1 bool
			result2 error
		})
	}
	fake.existsReturnsOnCall[i] = struct {
		result1 bool
		result2 error
	}{result1, result2}
}

func (fake *FakeHeartbeat) Create() error {
	fake.createMutex.Lock()
	ret, specificReturn := fake.createReturnsOnCall[len(fake.createArgsForCall)]
	fake.createArgsForCall = append(fake.createArgsForCall, struct{}{})
	fake.recordInvocation("Create", []interface{}{})
	fake.createMutex.Unlock()
	if fake.CreateStub != nil {
		return fake.CreateStub()
	}
	if specificReturn {
		return ret.result1
	}
	return fake.createReturns.result1
}

func (fake *FakeHeartbeat) CreateCallCount() int {
	fake.createMutex.RLock()
	defer fake.createMutex.RUnlock()
	return len(fake.createArgsForCall)
}

func (fake *FakeHeartbeat) CreateReturns(result1 error) {
	fake.CreateStub = nil
	fake.createReturns = struct {
		result1 error
	}{result1}
}

func (fake *FakeHeartbeat) CreateReturnsOnCall(i int, result1 error) {
	fake.CreateStub = nil
	if fake.createReturnsOnCall == nil {
		fake.createReturnsOnCall = make(map[int]struct {
			result1 error
		})
	}
	fake.createReturnsOnCall[i] = struct {
		result1 error
	}{result1}
}

func (fake *FakeHeartbeat) Update() error {
	fake.updateMutex.Lock()
	ret, specificReturn := fake.updateReturnsOnCall[len(fake.updateArgsForCall)]
	fake.updateArgsForCall = append(fake.updateArgsForCall, struct{}{})
	fake.recordInvocation("Update", []interface{}{})
	fake.updateMutex.Unlock()
	if fake.UpdateStub != nil {
		return fake.UpdateStub()
	}
	if specificReturn {
		return ret.result1
	}
	return fake.updateReturns.result1
}

func (fake *FakeHeartbeat) UpdateCallCount() int {
	fake.updateMutex.RLock()
	defer fake.updateMutex.RUnlock()
	return len(fake.updateArgsForCall)
}

func (fake *FakeHeartbeat) UpdateReturns(result1 error) {
	fake.UpdateStub = nil
	fake.updateReturns = struct {
		result1 error
	}{result1}
}

func (fake *FakeHeartbeat) UpdateReturnsOnCall(i int, result1 error) {
	fake.UpdateStub = nil
	if fake.updateReturnsOnCall == nil {
		fake.updateReturnsOnCall = make(map[int]struct {
			result1 error
		})
	}
	fake.updateReturnsOnCall[i] = struct {
		result1 error
	}{result1}
}

func (fake *FakeHeartbeat) GetLastUpdateTimestamp() (time.Time, error) {
	fake.getLastUpdateTimestampMutex.Lock()
	ret, specificReturn := fake.getLastUpdateTimestampReturnsOnCall[len(fake.getLastUpdateTimestampArgsForCall)]
	fake.getLastUpdateTimestampArgsForCall = append(fake.getLastUpdateTimestampArgsForCall, struct{}{})
	fake.recordInvocation("GetLastUpdateTimestamp", []interface{}{})
	fake.getLastUpdateTimestampMutex.Unlock()
	if fake.GetLastUpdateTimestampStub != nil {
		return fake.GetLastUpdateTimestampStub()
	}
	if specificReturn {
		return ret.result1, ret.result2
	}
	return fake.getLastUpdateTimestampReturns.result1, fake.getLastUpdateTimestampReturns.result2
}

func (fake *FakeHeartbeat) GetLastUpdateTimestampCallCount() int {
	fake.getLastUpdateTimestampMutex.RLock()
	defer fake.getLastUpdateTimestampMutex.RUnlock()
	return len(fake.getLastUpdateTimestampArgsForCall)
}

func (fake *FakeHeartbeat) GetLastUpdateTimestampReturns(result1 time.Time, result2 error) {
	fake.GetLastUpdateTimestampStub = nil
	fake.getLastUpdateTimestampReturns = struct {
		result1 time.Time
		result2 error
	}{result1, result2}
}

func (fake *FakeHeartbeat) GetLastUpdateTimestampReturnsOnCall(i int, result1 time.Time, result2 error) {
	fake.GetLastUpdateTimestampStub = nil
	if fake.getLastUpdateTimestampReturnsOnCall == nil {
		fake.getLastUpdateTimestampReturnsOnCall = make(map[int]struct {
			result1 time.Time
			result2 error
		})
	}
	fake.getLastUpdateTimestampReturnsOnCall[i] = struct {
		result1 time.Time
		result2 error
	}{result1, result2}
}

func (fake *FakeHeartbeat) Invocations() map[string][][]interface{} {
	fake.invocationsMutex.RLock()
	defer fake.invocationsMutex.RUnlock()
	fake.existsMutex.RLock()
	defer fake.existsMutex.RUnlock()
	fake.createMutex.RLock()
	defer fake.createMutex.RUnlock()
	fake.updateMutex.RLock()
	defer fake.updateMutex.RUnlock()
	fake.getLastUpdateTimestampMutex.RLock()
	defer fake.getLastUpdateTimestampMutex.RUnlock()
	return fake.invocations
}

func (fake *FakeHeartbeat) recordInvocation(key string, args []interface{}) {
	fake.invocationsMutex.Lock()
	defer fake.invocationsMutex.Unlock()
	if fake.invocations == nil {
		fake.invocations = map[string][][]interface{}{}
	}
	if fake.invocations[key] == nil {
		fake.invocations[key] = [][]interface{}{}
	}
	fake.invocations[key] = append(fake.invocations[key], args)
}

var _ utils.Heartbeat = new(FakeHeartbeat)
