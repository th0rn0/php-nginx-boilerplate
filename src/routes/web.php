<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('/orders', 'OrderController@index');
// Route::get('/orders/{order_id}', 'OrderController@show');
Route::get('/orders/{order_id}/lines', 'OrderController@getLinesByOrder');

Route::get('/users/{user_id}/orders', 'OrderController@getByUser');

Route::get('/mintOrders', 'OrderController@getMintOrders');
