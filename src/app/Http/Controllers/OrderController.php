<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Order;
use App\WebUser;
use Redirect;
use GuzzleHttp\Exception\ClientException;
use GuzzleHttp\Psr7;

class OrderController extends Controller
{
    public function index(Request $request)
    {
		$unexported_orders = $this->prepareSelectQuery()
			->select('orders.web_Order_No')
			->get();

    	dd($unexported_orders->toArray());
    }

    public function getByUser(Request $request, string $user_id)
    {
		$unexported_orders = $this->prepareSelectQuery($request->query('type','Email'))
			->where('users.web_User_ID', $user_id)
			->select('orders.web_Order_No', 'orders.web_Customer_Order_No', 'orders.web_Order_Date', 'orders.web_Delivery_Date', 'orders.web_Delivery_Date_Latest', 'orders.web_Branch_Code', 'orders.web_Branch_Name', 'orders.web_CLOC1', 'orders.web_CLOC2', 'orders.web_CLOC3', 'orders.web_CNAM', 'orders.web_CADD1', 'orders.web_CADD2', 'orders.web_CADD3', 'orders.web_CADD4', 'orders.web_CADD5', 'web_Order_Date_Valid')
			->get();

    	dd($unexported_orders->toArray());
    }

    public function show(Request $request, string $order_id)
    {
		$unexported_orders = $this->prepareSelectQuery()
			->where('orders.web_Order_No', $order_id)
			->get();

    	dd($unexported_orders->toArray());
    }

    public function getLinesByOrder(Request $request, string $order_id)
    {
		$unexported_orders = $this->prepareSelectQuery()
			->where('orders.web_Order_No', $order_id)
			->join('orders_lines', 'orders.web_Order_No', 'orders_lines.web_Order_No')
			->select('orders_lines.*')
			->get();

    	dd($unexported_orders->toArray());
    }

    public function getMintOrders(Request $request)
    {
    	$user_id = $request->user_id;

    	$mintUsername = DB::table('users')
    		->where('web_User_ID', $user_id)
    		->pluck('web_Integration_Mint_Username');

    	$mintPassword = DB::table('users')
    		->where('web_User_ID', $user_id)
    		->pluck('web_Integration_mint_Password');

    	// Get API token from Mint
		$client = new \GuzzleHttp\Client([
			'http_errors' => false
			// 'verify' => false
		]);


		// $mintUsername = 'ryan@xedi.com';
		// $mintPassword = 'password';

		$response = $client->request('GET', 'https://api.mintsoft.co.uk/api/Auth?UserName=' . $mintUsername[0] . '&Password=' . $mintPassword[0]);
		$statuscode = $response->getStatusCode();

		if (200 === $statuscode) {
			$mintToken = (json_decode((string) $response->getBody()));
		}
		else {
			abort($statuscode);
		};

    	dd($mintToken);
    }

    private function prepareSelectQuery(string $integration_type = 'Email')
    {
		return DB::table('orders')
			->join('users', 'orders.web_User_ID', 'users.web_User_ID')
			->where('users.web_Integration_Package', $integration_type)
			->whereNull('orders.web_Integration_Exported');
    }

}
