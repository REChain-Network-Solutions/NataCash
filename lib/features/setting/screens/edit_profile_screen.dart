import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:six_cash/features/setting/domain/models/profile_model.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/setting/controllers/edit_profile_controller.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/camera_verification/controllers/camera_screen_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/data/api/api_client.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/common/widgets/custom_image_widget.dart';
import 'package:six_cash/common/widgets/custom_small_button_widget.dart';
import 'package:six_cash/features/auth/widgets/gender_field_widget.dart';
import 'package:six_cash/features/auth/widgets/sign_up_input_widget.dart';
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  TextEditingController occupationTextController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ProfileController profileController = Get.find<ProfileController>();
    occupationTextController.text = profileController.userInfo!.occupation ?? '';
    firstNameController.text = profileController.userInfo!.fName ?? '';
    lastNameController.text = profileController.userInfo!.lName ?? '';
    emailController.text = profileController.userInfo!.email ?? '';
    Get.find<EditProfileController>().setGender(profileController.userInfo!.gender ?? 'Male') ;
    Get.find<EditProfileController>().setImage(profileController.userInfo!.image ?? '') ;
  }
  @override
  Widget build(BuildContext context) {
   return GetBuilder<EditProfileController>(builder: (controller) {

    return ModalProgressHUD(
      inAsyncCall: controller.isLoading,
      progressIndicator: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      child: PopScope(
        canPop: false,
        onPopInvoked: (_)=> _onWillPop(context),
        child: Scaffold(
          appBar: CustomAppbarWidget(title: 'edit_profile'.tr, onTap: (){
             if(Get.find<CameraScreenController>().getImage != null){
               Get.find<CameraScreenController>().removeImage();
             }
            Get.back();
          }),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: Dimensions.paddingSizeLarge,
                        ),
                         Stack(
                           clipBehavior: Clip.none, children: [
                               GetBuilder<CameraScreenController>(builder: (imageController){
                                 return imageController.getImage == null ?
                                     GetBuilder<ProfileController>(builder: (proController){
                                       return proController.isLoading ? const SizedBox() : Container( height: 100,width: 100,
                                         decoration: BoxDecoration( borderRadius: BorderRadius.circular(100)),
                                         child: ClipRRect(
                                           borderRadius: BorderRadius.circular(100),
                                           child: CustomImageWidget(
                                               placeholder: Images.avatar,
                                               height: 100, width: 100,
                                               fit: BoxFit.cover,
                                               image : '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl
                                               }/${proController.userInfo!.image ?? ''}'),
                                         ),
                                       );
                                     })
                                     :  Container(
                                   height: 100,width: 100,
                                   decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       border: Border.all(color: Theme.of(context).textTheme.titleLarge!.color!,width: 2),
                                       image: DecorationImage(
                                         fit: BoxFit.cover,
                                         image:FileImage(
                                           File(imageController.getImage!.path),
                                         ),
                                       )
                                   ),
                                 );
                               },),


                              Positioned(
                                bottom: 5,
                                right: -5,
                                  child: InkWell(
                                    onTap: ()=> Get.find<AuthController>().requestCameraPermission(fromEditProfile: true),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).cardColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorResources.getShadowColor().withOpacity(0.08),
                                              blurRadius: 20,
                                              offset: const Offset(0, 3),
                                            )
                                          ]
                                      ),
                                      child: const Icon(Icons.camera_alt,size: 24,),

                                    ),
                                  ),

                              )
                            ],
                          ),
                        const SizedBox(
                          height: Dimensions.paddingSizeLarge,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: GenderFieldWidget(fromEditProfile: true),
                        ),

                        SignUpInputWidget(
                          occupationController: occupationTextController,
                          fNameController: firstNameController,
                          lNameController: lastNameController,
                          emailController: emailController,
                        ),
                      ],
                    ),
                  ),

              ),
              Container(
                padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeDefault,
                  right: Dimensions.paddingSizeDefault,
                  bottom: Dimensions.paddingSizeDefault,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomSmallButtonWidget(
                        onTap: () => _saveProfile(controller),
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        text: 'save'.tr,
                        textColor: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    });
  }
  void _onWillPop(BuildContext context) async {

    if(Get.find<CameraScreenController>().getImage != null){
      Get.find<CameraScreenController>().removeImage();
    }

    Future.delayed(const Duration(milliseconds: 0)).then((value) => Get.back());




  }
  _saveProfile(EditProfileController controller){
    String fName = firstNameController.text;
    String lName = lastNameController.text;
    String email = emailController.text;
    String? gender = controller.gender;
    String occupation = occupationTextController.text;
    File? image = Get.find<CameraScreenController>().getImage;


    List<MultipartBody> multipartBody;
    if(image != null){
      multipartBody = [MultipartBody('image',image )];
    }else{
      multipartBody = [];
    }


    ProfileModel editProfileBody  = ProfileModel(
      fName: fName,
      lName: lName,
      gender: gender,
      occupation: occupation,
      email: email,
    );
    controller.updateProfileData(editProfileBody, multipartBody).then((value) {
      if(value) {
        Get.find<ProfileController>().getProfileData();
      }
    });

  }
}
