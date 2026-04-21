<?php

namespace App\Http\Controllers\Api;

use App\Models\Shipment;
use App\Models\Item;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class ShipmentController extends Controller
{
    /**
     * Get all shipments for current user
     */
    public function index()
    {
        try {
            $shipments = Shipment::where('user_id', auth('api')->id())
                ->with('items')
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $shipments,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Create new shipment
     */
    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'recipient_name' => 'required|string|max:255',
                'recipient_phone' => 'required|string|max:20',
                'destination' => 'required|string|max:255',
                'city_destination' => 'required|string|max:100',
            ]);

            // Generate unique tracking number
            $trackingNumber = 'EH' . strtoupper(Str::random(8)) . date('YmdHis');

            $shipment = Shipment::create([
                'user_id' => auth('api')->id(),
                'tracking_number' => $trackingNumber,
                'recipient_name' => $validated['recipient_name'],
                'recipient_phone' => $validated['recipient_phone'],
                'destination' => $validated['destination'],
                'city_destination' => $validated['city_destination'],
                'status' => 'pending',
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Pengiriman berhasil dibuat',
                'data' => $shipment,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Get single shipment
     */
    public function show($id)
    {
        try {
            $shipment = Shipment::findOrFail($id);

            // Verify user owns this shipment
            if ($shipment->user_id != auth('api')->id()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            $shipment->load('items');

            return response()->json([
                'success' => true,
                'data' => $shipment,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Update shipment
     */
    public function update(Request $request, $id)
    {
        try {
            $shipment = Shipment::findOrFail($id);

            if ($shipment->user_id != auth('api')->id()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            $validated = $request->validate([
                'recipient_name' => 'sometimes|string|max:255',
                'recipient_phone' => 'sometimes|string|max:20',
                'destination' => 'sometimes|string|max:255',
                'city_destination' => 'sometimes|string|max:100',
                'status' => 'sometimes|in:pending,in_transit,delivered,cancelled',
            ]);

            $shipment->update($validated);

            return response()->json([
                'success' => true,
                'message' => 'Pengiriman berhasil diperbarui',
                'data' => $shipment,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Delete shipment
     */
    public function destroy($id)
    {
        try {
            $shipment = Shipment::findOrFail($id);

            if ($shipment->user_id != auth('api')->id()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            $shipment->delete();

            return response()->json([
                'success' => true,
                'message' => 'Pengiriman berhasil dihapus',
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
            ], 500);
        }
    }
}
