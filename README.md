# BookStore

## 구현 내용
### 검색 화면
- Core Data를 이용하여 검색 결과를 캐시합니다.
- 페이지 단위로 검색 결과를 로딩합니다.  
  - Core Data에 캐시되어있지 않으면 API 호출을 하고, 호출한 결과를 캐시합니다.
- 네트워크 연결이 해제되었을때 API 호출시 Alert이 띄워집니다.
  - 네트워크 연결이 해제되었더라도 Core Data에 캐시되어있다면 캐시된 결과를 표시하고, 
  - 캐시되어있지 않다면 API 호출을 시도하지만 에러가 발생하면 Alert이 표시됩니다.
- 검색 결과에 대한 메모가 존재한다면, 메모 이미지가 표시됩니다.
- Scroll To Top 버튼을 터치하면 가장 처음 결과로 스크롤이 이동합니다.

|페이지 단위로 검색 결과 로딩|
|---|
|<img src="https://user-images.githubusercontent.com/60725934/193575756-32cad12d-4422-4aba-ade8-6729e0199c7f.gif" width="400" height="400"/>|

|네트워크 연결 유실시 Alert 표시|메모 존재시 메모 이미지 표시|
|---|---|
|<img src="https://i.imgur.com/iZqIZra.gif" width="200" height="400"/>|<img src="https://i.imgur.com/Y3m0qAH.png" width="200" height="400"/>|

### 상세 화면
|새 메모 추가|웹뷰 표시|
|---|---|
|<img src="https://user-images.githubusercontent.com/60725934/193577274-5086b937-1b7e-4731-be34-5039f00f94ed.gif" width="200" height="400"/>|<img src="https://user-images.githubusercontent.com/60725934/193577538-c5789898-7175-45f7-907b-5a1e2c16e8d1.gif" width="200" height="400"/>|

## Directory Tree
```
├── BookStore
│   ├── BookStoreApp
│   ├── Presentation
│   │   ├── Search
│   │   │   ├── Model
│   │   │   ├── View
│   │   │   └── ViewModel
│   │   ├── Detail
│   │   │   ├── Model
│   │   │   ├── View
│   │   │   └── ViewModel
│   │   └── Extension
│   ├── Repository
│   ├── CoreData
│   │   ├── Entity
│   │   ├── Error
│   ├── Network
│   │   ├── DTO
│   │   ├── Request
│   │   ├── Error
│   │   ├── Support
└── └── └── Interface
└── BookStoreTest
    └── SearchView
        └──TestDouble
```
