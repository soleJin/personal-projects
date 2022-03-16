# OPEN API를 이용한 날씨앱을 만들어보자!  

<br>

<center><img src="https://user-images.githubusercontent.com/73588175/158507998-e5727882-1040-40d7-b77c-e050b6b80bd0.gif" width="310"></center>

# Index
- [기능](#기능)
    - Main View(첫 화면)
    - Search View
    - Detail View
- [역할](#역할)
    - ViewController
        - MainViewController
        - LocationSearchTableViewController
        - DetailViewControoler
    - Model
        - NetworkModel
        - WeatherData
        - AddressManager
        - UnitStyle
        - ETC
        - MainViewModel
    - View
        - MainView
        - DetailView
- [고민내용](#고민내용)
    - MVVM
    - 화면전환
    - 정보전달
    - UserDefaults
    - MainView와 DetailView에서 달라지는 지역명
    - GCD의 사용
- [수정이 필요한 부분](#수정이-필요한-부분)
    - detailWeatherTableView - cell noreuse 문제
    - CLLocationManager를 mainViewController가 소유하는 문제
    - autolayout 문제(가로모드)
    - CLGeocoder 주소변환 문제
- [공부한 내용](#공부한-내용)  
    - [CLLocationManager](https://solejin.github.io/cllocation)
    - [MapKit-Local Search](https://solejin.github.io/local-search)
    - [ARC](https://solejin.github.io/arc)
    - [CLGeocoder](https://solejin.github.io/clgeocoder)
    - [Date](https://solejin.github.io/date)
    - [String Format Specifiers](https://solejin.github.io/string-format-specifiers)
    - [UserDefaults](https://solejin.github.io/user-defaults)
    - [Networking](https://solejin.github.io/networking)

<br>
<br>

# 기능
### Main View(첫 화면)  
- 모든 정보는 한국어를 기준으로 한다.
- 도시이름, 날씨아이콘, 현재온도, 현재습도의 날씨정보를 표시한다.
- 사용자의 현재 위치의 날씨를 표시한다.
- 앱을 껐다 킬 경우, 사용자가 추가한 도시 목록을 불러온다.
- 도시이름, 온도, 습도를 정렬할 수 있다.
- 사용자 정렬할 수 있다.
- 온도 단위(F/C)를 설정할 수 있다.
- 각 도시정보를 선택하면 Detail View로 이동한다.
- '지역명을 검색하세요' 버튼을 누르면 Search View로 이동한다.  
<br>

### Search View
- 지역명을 검색하면 해당 지역명이 포함된 주소가 리스트에 표시된다.
- 각 도시정보를 선택하면 Detail View로 이동한다.  
<br>

### Detail View
- Main View 또는 Search View에서 선택된 도시의 날씨정보를 표시한다.
- 선택된 도시의 주소와 현재온도, 체감온도는 **고정** 화면으로, 상세 날씨 정보와 시간 단위의 하루 날씨, 일 단위의 주간 날씨는 **스크롤** 화면으로 표시한다.
- Search View에서 선택되어 이동됐을 경우, 추가 버튼을 누르면 Main View의 목록에 추가되며 Main View로 이동한다.  
<br>
<br>

# 역할
### 1) View Controller

![viewcontroller구성](https://user-images.githubusercontent.com/73588175/156976616-f48c422d-c63d-41fc-a6f2-5c4a14e9ddc6.png)

### <span style="font-weight: bold; color: #F19E38;">MainViewController</span>
- 사용자의 현재 위치 받아오기 - CLLocationManager ([공부한 내용](https://solejin.github.io/cllocation)) 
- mainViewModel을 통해 날씨정보 받아오기  
    `protocol CurrentWeatherListDataUpdatable`을 채택해 mainViewModel의 currentWeatherList의 데이터가 바뀔 때 마다 Main View의 즐겨찾는 도시 목록(cityTableView)을 리로드한다.  
- 현재위치 혹은 즐겨찾는 도시를 선택할 경우 Detail View로 이동  
    - `performSegue` method를 통해 화면전환
    - `prepare(for segue: UIStoryboardSegue, sender: Any?)` method를 통해 Detail View에 표시될 데이터(location) 정보전달 
- search button을 선택할 경우 Search View로 이동
- 도시목록 스와이프로 삭제 & 사용자 정렬  
- 즐겨찾는 도시, 온도, 습도 label을 누르면 정렬  
    선택된 label의 이미지 색깔이 회색에서 검정색으로 바뀌며, 이미지로 오름차순(⌃)과 내림차순(⌄)을 구분한다.  
    mainViewModel을 통해 각각의 데이터를 정렬한다.  
- 온도단위 (F/C) 설정  
    앱을 껐다 켰을 때 정보를 유지하기 위해 UserDefaults로 F/C를 저장하고, 그 데이터에 맞게 화면에 표시한다.  
    (날씨정보를 받아올 때 표준단위(K)로 받고, 화면에는 UserDefautls 값에 따라 F단위로 또는 C단위로 표시한다.)   
<br>

### <span style="font-weight: bold; color: #804DFB;">LocationSearchTableViewController</span>  
- MKLocalSearchCompleter에서 제안하는 주소목록만 나타내면 되기 때문에 TableViewController로 구현 
- SearchController를 통해 필요한 지역을 검색한다.  
- `protocol UISearchResultsUpdatint`을 채택해 사용자가 검색하는 텍스트를 실시간으로 업데이트 받는다.  
- MapKit을 통해 사용자가 검색한 텍스트가 포함된 주소 목록을 화면에 표시한다.  
- MapKit-Local Search ([공부한 내용](https://solejin.github.io/local-search))  
- 제안된 주소목록 중 하나를 선택하면 Detail View로 이동  
    - `performSegue` method를 통해 화면전환
    - `prepare(for segue: UIStoryboardSegue, sender: Any?)` method를 통해 Detail View에 표시될 데이터(location) 정보전달  
<br>

### <span style="font-weight: bold; color: #85A343;">DetailViewController</span>  
- detailWeatherTableView의 각 섹션에 알맞는 정보를 전달하기 위해 protocol과 delegate property를 선언한다.  
    - `weak var currentWeatherDelegate`
    - `weak var hourlyWeatherListDelegate`
    - `weak var dailyWeatherListDelegate`
- 전달받은 location 정보로 날씨정보를 받아온다.  

![detailVeiwController](https://user-images.githubusercontent.com/73588175/157540380-9fa1d9a4-0d65-497b-9176-d3c3fc75fbd9.png)  

- 추가버튼을 누르면 delegate를 통해 mainView의 cityTableView에 weather정보가 추가되고, mainView로 이동한다.  
    - `weak var addWeatherDelegate`  
- ARC ([공부한 내용](https://solejin.github.io/arc))  
<br>

### 2) Model
### NetworkModel
- **URLManager**  
    - Main View의 날씨정보와 Detail View의 날씨 정보를 받아오는 url이 다르기 때문에, `enum APIType`을 선언해 알맞게 활용한다.  
    - url query에 위도와 경도 외에 language(언어), units(단위) 등을 추가로 설정할 수 있다. (한국어, 표준단위로 설정한다.)  
- **WeatherAPI**  
    - 완성된 url로 날씨정보를 받아온다.
- **ImageManager**   
    - 즐겨찾는 도시가 많아질수록 로딩 속도가 느려짐을 방지하기 위해 이미지를 캐싱한다.     
<br>

### WeatherData
- **CurrentWeatherResponse**
    - mainView에서 네트워킹을 통해 받는 데이터 모델
    - **CurrentWeather** - CureentWeatherResponse를 가공해 Main View에서 사용됨
- **DetailWeather**
    - detailView에서 네트워킹을 통해 받는 데이터 모델, Detail View에서 사용됨   
<br>

### AddressManager
- 네트워킹에서 받아온 날씨 데이터의 프로퍼티 중 하나인 cityName을 한글로 바꾸는 역할  
    CLGeocoder ([공부한 내용](https://solejin.github.io/clgeocoder))   
<br>

### UnitStyle
- **DefalutValue**   
    - **InitialLocation** - 사용자가 위치접근에 허용하지 않을 때 사용할 기본값  
    - **City** - 앱을 처음 켰을 때 한 번 사용할 즐겨 찾는 도시 목록 
- **Unit**  
    - **TemperatureUnit** - UserDefaults에 저장할 온도 단위값
    - **WeatherSymbols** - 날씨정보 단위 문자 모양 저장(예: %, º)
    - **TimeUnit** - 화면에 표시할 날짜 유형(예: 월요일, 03시, 05시 22분) Date ([공부한 내용](https://solejin.github.io/date))
    - **ExtensionDouble**
        - `var inFahrenheit` - 화면에 표시할 때 K -> F로
        - `var inCelsius` - 화면에 표시할 때 K -> C로
        - `var oneDecimalPlaceInString` - 화면에 표시할 때 소숫점 첫번째 자리까지 표시
    - **ExtensionInt**  
        - `func converToDateString(_:)` - 네트워킹에서 받은 날씨 정보의 dateTime을 한국 시간에 맞게 변환   
- **ExtensionString**  
    - `func convertToNSMutableAttributedString(ranges:fontSize:fontWeight:fontColor:)` - SearchView에서 사용자가 검색한 텍스트의 글자만 속성 변환   
- **ExtensionDictionary**  
    - `func findIndex(for:)` - 값으로 키를 찾기 위한 메서드    
<br>

### ETC
- **AlertManager**   
- **UserDefaults**  
    앱을 껐다 켰을 때 즐겨찾는 도시 목록을 유지하기 위해 mainViewModel의 currentWeatherList의 좌표값을 데이터로 저장 ([공부한 내용](https://solejin.github.io/user-defaults))   
<br>

### MainViewModel  
- MainViewController의 일을 덜어주기 위해 만든 모델
- WeatherAPI를 통해 위도와 경도를 이용해 날씨정보를 받는다. Networking ([공부한 내용](https://solejin.github.io/networking))
- 받은 날씨정보를 `currentWeatherList`에 추가한다.
- `currentWeatherList`는 값이 바뀔 때마다 property observer `didSet` 에서 delegate를 통해 mainViewController에게 알린다.  
- `weak var currentWeatherListDelegate` 
- 각 도시, 온도, 습도를 정렬한다.  
- 앱을 껐다 켜도 사용자 정렬을 유지한다.
- `protocol UserAddWeatherDataUpdatable`을 채택해 사용자가 추가한 weatherData를 currentWeatherList의 첫번째 index에 추가한다.  
<br>

### 3) View
### <span style="font-weight: bold; color: #F19E38;">MainView</span>
- **CityListCell** - 즐겨 찾는 도시 목록에 표시될 셀   
<br>

### <span style="font-weight: bold; color: #85A343;">DetailView</span>
- **CurrentWeather** - first section  
    - CurrentWeatherSectionHeaderView
    - CurrentTableViewCell   
        - `protocol CurrentWeatherDataUpdatable`을 채택해 날씨정보를 받는다.
- **HourlyWeather** - second section  
    - HourlyWeatherSectionHeaderView
    - HourlyTableViewCell
        - `protocol HourlyWeatherListDataUpdatable`을 채택해 날씨정보를 받아  
            셀 내부의 컬렉션뷰를 리로드한다.
        - HourlyGridCell
- **DailyWeather** - third section    
    - DailyWeatherSectionHeaderView
    - DailyTableViewCell  
        - `protocol DailyWeatherListDataUpdatable`을 채택해 날씨정보를 받아  
            셀 내부의 테이블뷰를 리로드한다.
        - DailyListCell  
<br>
<br>

# 고민내용
### MVVM
- 얼마 전에 디자인패턴([공부한 내용](https://solejin.github.io/design-patterns))을 공부했어서 적용해보고 싶은 마음에 MVVM으로 진행했다. 막상 적용해보고 나니, 좀 더 이해가 필요함을 느꼈다. 단지 viewController의 역할을 덜기만 하면 된다고 생각했는데, viewmodel과 controller의 관계에서 데이터의 흐름을 파악하는 방법을 잘못 생각했던 것 같다.  
MVVM과 자주 사용되는 SwiftUI에서 어떻게 사용되는지 다시 공부한 후 도전해봐야겠다.   
<br>

### 화면전환
- navigation과 modality 사이에서 고민이 있었다. navigation은 화면이 목록 -> 목록 -> 목록, 혹은 목록 -> 목록 -> 항목으로 전환될 때 사용(내용이 이어짐)하고, modality는 목록 -> 항목, 혹은 항목 -> 항목으로 전환될 때 사용(내용이 벗어남)한다고 생각했다. 이 생각에는 변함이 없지만, 'modality를 연속으로 두 번 띄워도 되는건가?'의 문제 때문에 고민이었다. HIG 문서에서 확인할 수 없어 기본앱을 참고했다.  
(두 번 모두 modality로 화면전환을 한다.)   
<br>

### 정보전달  
- **화면 간 정보전달**  
화면 간 정보전달은 스토리보드를 이용한 seg를 통해 한다.   

- **화면 안 정보전달(DetailView - detailWeatherTableView)**  
mainView에서 선택된 도시의 상세날씨정보를 표시하는 detailView에서 모든 날씨 정보(현재, 상세, 하루, 주간 날씨)를 갖고 있다.  
이 때, detailViewContoller에 상수를 선언해 모든 날씨정보를 갖게 한다면, detailWeatherTableView의 각 섹션의 셀에 맞게 날씨 정보를 전달해야하기 때문에 상수에서도 셀에서도 날씨 정보를 갖고 있게 된다. 그렇기 때문에 상수를 선언하지 않고 delegate 방식으로 각 섹션의 셀에 정보를 바로 전달한다.  
하지만 테이블뷰의 대신 스크롤뷰로 만들었다면, 테이블뷰 안에 컬렉션뷰와 테이블뷰를 넣지 않아도 되기 때문에 데이터를 전달하지 않아도 됐을까? 라는 생각이 든다. (다음엔 스크롤뷰로 만들어봐야지)   
<br>

### UserDefaults  
사용자가 앱을 껐다 켜도 정보가 유지될 수 있도록 UserDefaults를 이용한다.   
- **온도 단위 저장**  
날씨정보를 표준단위(kelvin)로 받아오고, 사용자의 선호에 따라 화씨(fahrenheit) 혹은 섭씨(celsius)로 표시하기 위해 사용자가 mainView의 segmentedControl을 탭할 때마다 문자열로 저장한다. 그 값이 fahrenheit일 경우 화씨로, celsius일 경우 섭씨로 전체 화면의 온도단위를 바뀌게 했다.  

- **좌표리스트 저장**  
mainView에서 사용자가 지정한 즐겨찾는 도시목록을 그대로 불러오기 위해 각 도시의 좌표를 저장한다.  
UserDefaults는 기본값만 저장되기 때문에 처음엔 각각 위도와 경도를 배열로 받아 저장했는데, custom type을 그대로 저장할 순 없을까? 찾아보다 데이터타입으로 저장하는 방법을 선택했다.  
각각 배열로 저장할 경우 저장하려는 타입(custom type)이 수정된다면 UserDefaults에 저장하는 코드도 수정해야 하는 반면,  
custom type을 데이터로 변환하여 저장하면 저장하려는 타입이 수정되더라도 UserDefaults에 저장하는 코드는 수정하지 않아도 되는 이점이 있다.  
<br>

### MainView와 DetailView에서 달라지는 지역명  
- 처음 날씨데이터를 불러올 때 mainView는 cityName으로, detailView는 coordinate로 데이터를 받기 때문에 나타나는 현상이다. 그래서 때에 따라 cityName 혹은 coordinate로 받아오는 Weather API의 fetchWeather 메서드를 coordinate로만 받아오도록 수정했다.  
<br>

### GCD의 사용
- **MainViewModel**  
    - 도시목록의 날씨정보를 받아올 때 여러 개의 좌표로 네트워킹하기 때문에 오래걸리리지만, URLSession은 따로 설정해주지 않아도 비동기로 작동하기때문에 GCD를 사용하지 않았다.  
    - 다만, `currentWeatherList` 프로퍼티에 여러 쓰레드에서 같이 접근하면 교착상태가 발생할 수 있으므로 `append` 부분만 `DispatchQueue(label: "serial").sync {}`를 사용했다.  
        - **즐겨찾는 도시목록을 사용자가 지정한 대로 정렬**하려면 append 후에 해야하기 때문에 `sync`를 사용했다.  
        `async`를 사용하면 테이블뷰에서 index오류가 난다.  
- **ImageManager**  
    - 날씨아이콘을 받아오는 작업은 오래걸리기 때문에 `DispatchQueue.global().async {}`를 사용했다.  
    - 날씨아이콘을 화면에 표시하는 작업은 바로 이루어져야 하기 때문에 `DispatchQueue.main.async {}`를 사용했다.   
<br>
<br>

# <span style="font-weight: bold; color: #3C4C6C;">수정이 필요한 부분</span>
### detailWeatherTableView - cell noreuse 문제  
- 각 section마다 다른 cell을 사용하기 때문에 resuse를 하지 않아 경고가 떴다.  
cell의 재사용이 어떤 의미인지 다시 한 번 살펴봐야할 것 같다.  
<br>

### CLLocationManager를 mainViewController가 소유하는 문제 
- mainViewController는 화면과 관련된 일만 하도록 설정하고 싶었는데, 현재위치 관련해서 일을 하고 있다.  
<br>

### autolayout 문제(가로모드)  
- autolayout을 잘 설정하지 못했다. 추가 공부가 필요하다.    
<br>

### CLGeocoder 주소변환 문제 
- 외국 주소 중 한글로 변환하지 못하는 지역들이 있다.  
<br>
<br>

