import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MealPage extends StatefulWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  _MealPageState createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              stretch: true,
              toolbarHeight: size.height * 0.1,
              collapsedHeight: size.height * 0.1,
              expandedHeight: size.height * 0.2,
              title: const Text(
                "Alimentação",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                  stretchModes: <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(fit: StackFit.expand, children: <Widget>[
                    Image.asset(
                      "assets/images/bg3.jpg",
                      fit: BoxFit.cover,
                      color: const Color(0xaa212121),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ])),
            ),
          ];
        },
        body: Container(
          child: ListView(
            children: [
              _buildMealSection(
                context,
                'Café da manhã',
                'assets/images/lanche.jpg',
                '500 calorias',
              ),
              _buildMealSection(
                context,
                'Almoço',
                'assets/images/lanche.jpg',
                '800 calorias',
              ),
              _buildMealSection(
                context,
                'Jantar',
                'assets/images/lanche.jpg',
                '600 calorias',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adicione aqui a lógica para enviar a foto da refeição atual
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildMealSection(
      BuildContext context, String title, String imageAsset, String calories) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Image.asset(
                imageAsset,
                height: 60,
                width: 60,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  calories,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Adicione aqui a lógica para curtir a refeição
                },
                icon: Icon(Icons.favorite_border),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Adicione aqui a lógica para abrir a modal com o seletor de outras refeições
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 300,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Selecione um alimento:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 200,
                            autoPlay: true,
                            enlargeCenterPage: true,
                          ),
                          items: [
                            _buildCarouselItem(
                              'assets/images/lanche.jpg',
                              'Nome do alimento 1',
                              'Descrição do alimento 1',
                              '100 calorias',
                            ),
                            _buildCarouselItem(
                              'assets/images/lanche.jpg',
                              'Nome do alimento 2',
                              'Descrição do alimento 2',
                              '200 calorias',
                            ),
                            _buildCarouselItem(
                              'assets/images/lanche.jpg',
                              'Nome do alimento 3',
                              'Descrição do alimento 3',
                              '300 calorias',
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Trocar alimento
                          },
                          child: Text('Trocar alimento'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Text('Trocar Alimento'),
          ),
        ],
      ),
    );
  }
}

Widget _buildCarouselItem(
    String image, String name, String description, String calories) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          image,
          height: 150,
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 4),
        Text(
          calories,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}