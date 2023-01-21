
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';

import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

const _URL_NEWS = 'newsapi.org';
const _URLVER = '/v2';
const _APIKEY = 'af963ae17afa45c29bf7c1e27c02a225';

class NewsService with ChangeNotifier{

  List<Article> headlines=[];
  String _selectedCategory = 'general';

  bool _isLoading = true;
  bool get isLoading => this._isLoading;

  List<Category> categories=[
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyball, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];
  
  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();

    categories.forEach((item) {
      this.categoryArticles[item.name] = <Article>[];
    });
  }

  

  getTopHeadlines() async {
    
    var urlUri =
      Uri.https(_URL_NEWS, '$_URLVER/top-headlines', {'apiKey': _APIKEY, 'country': 'us'});
    final resp = await http.get(urlUri);
    final newsResponse = new NewsResponse.fromJson(resp.body);
    
    print(newsResponse.status);
    //consumo de servicios web
    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  String get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    this._getArticlesByCategory(valor);
    notifyListeners();
  }

  _getArticlesByCategory(String category) async {
    if(this.categoryArticles[category]!.length > 0){
      return this.categoryArticles[category];
    }
    var urlUri =
      Uri.https(_URL_NEWS, '$_URLVER/top-headlines', {'apiKey': _APIKEY, 'country': 'mx', 'category': category});
    final resp = await http.get(urlUri);
    final newsResponse = new NewsResponse.fromJson(resp.body);
    
    
    this.categoryArticles[category]!.addAll(newsResponse.articles);
    
    notifyListeners();
  }
  List<Article>? get getArticulosCategoriaSeleccionada => this.categoryArticles[this.selectedCategory];

}