# angular基础教程
摘录https://coursetro.com/posts/code/174/Angular-8-Tutorial-&-Crash-Course

## 环境安装
* node
* @angular/cli

创建angular项目
```
ng new angular-crash-cource
```

## 运行项目
```
ng serve -o
```

## 目录结构
angular项目目录和文件接口类似如下：
```
> e2e 端对端测试
> node_modules 项目npm依赖包
> src
  > app 项目代码主体目录，包含路由、组件等
  > assets 资源文件
  > environments 开发环境配置
  ..index.html 应用的入口文件
  ..styles.scss 全局css
```

## 组件
angular项目的基础构建块，组件包含3各组成部分：
* imports
* component decorator
* component logic

打开/src/app/app.component.ts:
```
import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'myapp';
}
```
## 创建导航
打开/src/app/app.component.html，替换为如下代码：
```
<header>
  <div class="container">
    <a routerLink="/" class="logo">CoolApp</a>
    <nav>
      <ul>
        <li><a href="#" routerLink="/">Home</a></li>
        <li><a href="#" routerLink="/list">List</a></li>
      </ul>
    </nav>
  </div>
</header>


<div class="container">
  <router-outlet></router-outlet>
</div>
```
接下来，打开/app/style.scss替换为如下代码：
```
@import url('https://fonts.googleapis.com/css?family=Nunito:400,700&display=swap');

$primary: rgb(111, 0, 255);

body {
    margin: 0;
    font-family: 'Nunito', 'sans-serif';
    font-size: 18px;
}

.container {
    width: 80%;
    margin: 0 auto;
}

header {
    background: $primary;
    padding: 1em 0;

    a {
        color: white;
        text-decoration: none;
    }
    a.logo {
        font-weight: bold;
    }

    nav {
        float: right;

        ul {
            list-style-type: none;
            margin: 0;
            display: flex;

            li a {
                padding: 1em;

                &:hover {
                    background: darken($primary, 10%);
                }
            }
        }
    }
}

h1 {
    margin-top: 2em;
}
```

## 路由
使用Angular CLI 创建需要用到的组件
```
ng generate component home
ng generate component list
```

编辑/src/app/app-routing.module.ts：
```
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { HomeComponent } from './home/home.component'; // Add this
import { ListComponent } from './list/list.component'; // Add this


const routes: Routes = [
  { path: '', component: HomeComponent },              // Add this
  { path: 'list', component: ListComponent }           // Add this
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
```

## 单向数据绑定
需要组件到模版（或者相反方向）通信，成为单向数据绑定

打开/src/app/home/home.component.html ，替换为如下代码：
```
<h1>Welcome!</h1>

<div class="play-container">
    <p>You've clicked <span (click)="countClick()">this</span> {{ clickCounter }} times.</p>
</div>
```
打开home.component.ts，修改代码：
```
export class HomeComponent implements OnInit {

  clickCounter: number = 0;

  constructor() { }

  ngOnInit() {
  }

  countClick() {
    this.clickCounter += 1;
  }

}
```

修改home.component.scss文件：
```
span {
    font-weight: bold;
    background: lightgray;
    padding: .3em .8em;
    cursor: pointer;
}

.play-container {
    padding: 3em;
    border: 1px solid lightgray;
    margin-bottom: 1em;

    input {
        padding: 1em;
        margin-bottom: 2em;
    }
}
```

## 双向绑定
打开home.component.html，增加如下代码：
```
<div class="play-container">
    <p>
        <input type="text" [(ngModel)]="name"><br>
        <strong>You said: </strong> {{ name }}
    </p>
</div>
```
ngModel指令需要导入FormsModule
打开/src/app/app.module.ts:
```
// other imports
import { FormsModule } from '@angular/forms';

@NgModule({
  ...
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule       // add this
  ],
  providers: [],
  bootstrap: [AppComponent]
})
```
接下来，home.component.ts定义name属性：
```
clickCounter: number = 0; 
name: string = '';  // add this
```

## ng-template
模版中使用if and else逻辑
home.comonent.html最后加入如下代码：
```
<div class="play-container">
    <ng-template [ngIf]="clickCounter > 4" [ngIfElse]="none">
        <p>The click counter <strong>IS GREATER</strong> than 4.</p>
    </ng-template>

    <ng-template #none>
        <p>The click counter is <strong>not greater</strong> than 4.</p>
    </ng-template>
</div>
```

## 样式绑定
需要根据事件触发修改样式，可以使用类或者样式绑定

```
// inline-style
<div class="play-container" [style.background-color]="clickCounter > 4 ? 'yellow' : 'lightgray'">
// ngStyle multiple styles
<div class="play-container" [ngStyle]="{
    'background-color': clickCounter > 4 ? 'yellow' : 'lightgray',
    'border':           clickCounter > 4 ? '4px solid black' : 'none'}
">


```

## 类绑定
```
// single class
<div class="play-container" [class.active]="clickCounter > 4">
// multiple classes
<div class="play-container" [ngClass]="setClasses()">
```

修改home.component.scss
```
.active {
    background-color: yellow;
    border: 4px solid black;
}
.notactive {
    background-color: lightgray;
}
```

修改home.component.ts
```
setClasses() {
    let myClasses = {
      active: this.clickCounter > 4,
      notactive: this.clickCounter <= 4
    };
    return myClasses;
  }
```

## 服务
提供可复用服务，简化component业务逻辑，方便单元测试。
比如：获取API接口数据等

创建一个服务:
```
ng g s http
```
s是service的简单写法

## Angular HTTP Client
http.service.ts注入HttpClient服务
```
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class HttpService {

  constructor(private http: HttpClient) { }

  getBeer() {
    return this.http.get('https://api.openbrewerydb.org/breweries')
  }
}
```

/src/app/app.moudule.ts需要导入HttpClientModule
```
import { HttpClientModule } from '@angular/common/http';  // Add this

@NgModule({
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule   // Add here
  ],
```

打开list.component.ts，新增：
```
export class ListComponent implements OnInit {

  brews: Object;

  constructor(private _http: HttpService) { }

  ngOnInit() {
    this._http.getBeer().subscribe(data => {
      this.brews = data
      console.log(this.brews);
    }
  );
  }

}
```
修改template代码:
```
<h1>Breweries</h1>

<ul *ngIf="brews">
  <li *ngFor="let brew of brews">
    <p class="name">{{ brew.name }}</p>
    <p class="country">{{ brew.country }}</p>
    <a class="site" href="{{ brew.website_url }}">site</a>
  </li>
</ul>
```
修改scss代码：
```
ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-wrap: wrap;

    li {
        background: rgb(238, 238, 238);
        padding: 1em;
        margin-right: 10px;
        width: 20%;
        height: 200px;
        margin-bottom: 1em;
        display: flex;
        flex-direction: column;

        p {
            margin: 0;
        }

        p.name {
            font-weight: bold;
            font-size: 1.2rem;
        }
        p.country {
            text-transform: uppercase;
            font-size: .9rem;
            flex-grow: 1;
        }
    }
}
```

##发布
```
ng build --prod
```

