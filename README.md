<h1> <p align="center"> Temp Generator </h1>

<p align="center">
<img width="128" height="128" src="https://github.com/SoufianHossam/TempGenerator/blob/master/Template%20Generator/Supporting%20Files/Assets.xcassets/AppIcon.appiconset/1024.png?raw=true">
</p>

<h3 style=”color: gray;"> Temp Generator is a menu bar application for Mac OS X that helps you generate boilerplate code in a matter of seconds, just by drag and drop movements.
<br/>
<br/>                        
This will be very handy when you use MVVM, MVVM-R, MVP, VIPER and CleanSwift architectures. </h3> 
<br/>
<p align="center">
<img src="https://github.com/SoufianHossam/TempGenerator/blob/master/Template%20Generator/Supporting%20Files/Demo-min.gif?raw=true">
</p>

## Let's get started
<br/>

**First** .. create a new file with a name like that `#..#ViewController.swift` the app will replace `#..#` in file name and file content with the provided string.
<br/><br/>
**Second** .. write your boilerplate code like the following example then save:
```swift
//
//  #..#ViewController.swift

import UIKit

class #..#ViewController: UIViewController {
    // MARK:- IBOutlets
    
    // MARK:- Variables
    var router: #..#RoutingLogic!
    var viewModel: #..#BusinessLogic!
    
    // MARK:- Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDependencies()
    }
    
    private func setupDependencies() {
        
        router = #..#Router(viewController: self)
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Functions
    
}
```
<br/>

**Third** .. Drag this file into the app.
<br/>


**Fourth** .. Enter a scene name then hit generate.
<br/>


**Fifth** .. Drag the updated templates from the app into Xcode.

## Note you can import more than one template into the app (as in demo, I imported three swift files and one storyboad)

## Demo Video
[Download HQ Demo Video](https://github.com/SoufianHossam/TempGenerator/raw/master/Template%20Generator/Supporting%20Files/Demo.mov)
<br/>

## Installation
Clone this repo, build then run the app or simply [Download The App From Here](https://drive.google.com/uc?authuser=1&id=1zygoB93237bx8IZFXTSmQ-l1YLLruxFr&export=download)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details
