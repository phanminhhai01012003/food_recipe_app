import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/routes.dart';

Future showLikesListModal(BuildContext context, Future<List<Map<String, dynamic>>> fetch) async{
  return await showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    // ignore: deprecated_member_use
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (context) => LikeListModal(fetch: fetch)
  );
}

class LikeListModal extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> fetch;
  const LikeListModal({super.key, required this.fetch});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 500),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16, top: 10),
            decoration: ShapeDecoration(
              shape: StadiumBorder(),
              color: AppColors.grey
            ),
          ),
          SizedBox(height: 20),
          FutureBuilder(
            future: fetch, 
            builder: (context, snapshot){
              if (!snapshot.hasData || snapshot.hasError) {
                return Center(child: Icon(Icons.error, size: 100));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              var likes = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: likes.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () => checkDeviceRoute(likes[index]['id']),
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(likes[index]['avatar'],
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                      ),
                      title: Text(likes[index]['username'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                    ),
                  ),
                )
              );
            }
          ),
        ],
      ),
    );
  }
}