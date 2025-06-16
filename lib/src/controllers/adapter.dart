abstract class Adapter<T> {
  Future<void> createObject(T collection);
  Future<void> createMultipleObjects(List<T> collection);

  Future<void> getAllObjects();
  Future<void> getObjectById(int id);
  Future<void> getObjectsById(List<int> ids);

  Future<void> updateObject(T collection);

  Future<void> deleteObject(T collection);
  Future<void> deleteMultipleObject(List<int> ids);
}
