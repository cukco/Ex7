// CheckException
class OutOfStockException extends Exception {
    public OutOfStockException(String m) {
        super(m);
    }
}

class AbnormalQuantityException extends Exception {
    public AbnormalQuantityException(String m) {
        super(m);
    }
}

class InventoryRepo {
    public void update(String item, int qty) throws OutOfStockException, AbnormalQuantityException {
        if (qty > 10000) throw new AbnormalQuantityException("Cảnh báo: Số lượng " + qty + " quá lớn!");
        if (qty < 0) throw new OutOfStockException("Hết hàng!");
        System.out.println("Cập nhật kho thành công.");
    }
}

class InventoryService {
    InventoryRepo repo = new InventoryRepo();
    public void processUpdate(String item, int qty) throws OutOfStockException, AbnormalQuantityException {
        repo.update(item, qty);
    }
}

class InventoryController {
    InventoryService service = new InventoryService();
    public void handleRequest(String item, int qty) {
        try {
            service.processUpdate(item, qty);
        } catch (OutOfStockException | AbnormalQuantityException e) {
            System.out.println("Lỗi Controller: " + e.getMessage());
        }
    }
}

//UncheckedException
class InventoryRuntimeException extends RuntimeException {
    public InventoryRuntimeException(String m) {
        super(m);
    }
}

class InventoryRepoV2 {
    public void update(String item, int qty) {
        if (qty > 10000) throw new InventoryRuntimeException("Số lượng " + qty + " bất thường!");
        System.out.println("V2: Cập nhật thành công.");
    }
}

class InventoryServiceV2 {
    InventoryRepoV2 repo = new InventoryRepoV2();
    public void processUpdate(String item, int qty) {
        repo.update(item, qty);
    }
}

class GlobalExceptionHandler {
    public void handle(RuntimeException e) {
        System.out.println("[Global Log] " + e.getMessage());
    }
}
