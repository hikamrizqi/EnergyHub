<?php

namespace App\Http\Controllers\Api;

use App\Models\Item;
use Illuminate\Http\Request;

class ItemController extends Controller
{
    /**
     * Get all items untuk shipment tertentu
     */
    public function indexByShipment($shipmentId)
    {
        try {
            $items = Item::where('shipment_id', $shipmentId)
                ->with('category')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $items,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Create new item
     */
    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'shipment_id' => 'required|exists:shipments,id',
                'item_code' => 'required|string|max:100',
                'item_name' => 'required|string|max:255',
                'max_stok' => 'required|integer|min:1',
            ]);

            $item = Item::create($validated);

            return response()->json([
                'success' => true,
                'message' => 'Item berhasil ditambahkan',
                'data' => $item,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Get single item
     */
    public function show($id)
    {
        try {
            $item = Item::with('category', 'shipment')->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $item,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Update item
     */
    public function update(Request $request, $id)
    {
        try {
            $item = Item::findOrFail($id);

            $validated = $request->validate([
                'item_code' => 'sometimes|string|max:100',
                'item_name' => 'sometimes|string|max:255',
                'max_stok' => 'sometimes|integer|min:1',
            ]);

            $item->update($validated);

            return response()->json([
                'success' => true,
                'message' => 'Item berhasil diperbarui',
                'data' => $item,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Delete item
     */
    public function destroy($id)
    {
        try {
            $item = Item::findOrFail($id);
            $item->delete();

            return response()->json([
                'success' => true,
                'message' => 'Item berhasil dihapus',
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error: ' . $e->getMessage(),
            ], 500);
        }
    }
}
