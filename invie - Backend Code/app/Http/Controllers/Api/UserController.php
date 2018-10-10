<?php

namespace App\Http\Controllers\Api;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App;
use Response;
use App\Users;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    //

    public function Login(Request $request){

        $returnData['success'] =  false;
        $returnData['message'] = trans('message.general.GENERAL_ERROR');
        App::setLocale('du');
        $postData = $request->all();

        if(isset($postData) && count($postData) > 0){
            
            $validator = Validator::make($request->all(), 
            [
               // 'name' => 'required',
                'mo_no' => 'required|regex:/[0-9]/'
            ]);
    
            if ($validator->fails()) {
                $returnData['success'] = false;
                $returnData['message'] = $validator->messages()->first();
            }else{
                
                $checkExist = Users::where('mo_no', $request->get('mo_no'))->first();
                
                if($checkExist){
                    
                    $returnData['success'] = true;
                    $returnData['message'] = trans('message.general.LOGIN_SUCCESS');
                    $returnData['data'] = $checkExist;
                }else{
                    $returnData['success'] = false;
                    $returnData['message'] = trans('message.general.MO_NO_DOES_NOT_EXIST');
                }
            }
        }else{
            $returnData['success'] = true;
            $returnData['message'] = trans('message.general.INVALID_PARAMS');
        }

        return response()->json($returnData);
    }


    // Register the user
    public function Register(Request $request){

        $returnData['success'] =  false;
        $returnData['message'] = trans('message.general.GENERAL_ERROR');

        $postData = $request->all();

        if(isset($postData) && count($postData) > 0){
            
            $validator = Validator::make($request->all(), 
            [
                'name' => 'required',
                'mo_no' => 'required|regex:/[0-9]/'
            ]);
    
            if ($validator->fails()) {
                $returnData['success'] = false;
                $returnData['message'] = $validator->messages()->first();
            }else{
                
                $checkExist = Users::where('mo_no', $request->get('mo_no'))->first();
                
                if($checkExist){
                    $returnData['success'] = false;
                    $returnData['message'] = trans('message.api.MO_NO_ALREADY_EXIST');
                }else{
                    
                    // Create new user
                    $newUser = new Users();
                    $newUser->name = $request->get('name');
                    $newUser->mo_no = $request->get('mo_no');
                    $newUser->status = 1;
                    $newUser->created_at = date('Y-m-d h:i:s');
                    $newUser->save();

                    $returnData['success'] = true;
                    $returnData['data'] = Users::find($newUser->id);
                    $returnData['message'] = trans('message.general.REGISTRED_SUCCESS');
                }
            }
        }else{
            $returnData['success'] = true;
            $returnData['message'] = trans('message.general.INVALID_PARAMS');
        }

        return response()->json($returnData);
    }



}
