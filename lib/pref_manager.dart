import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {

  // Singleton pattern
  static final PrefManager _instance = PrefManager._internal();
  factory PrefManager() => _instance;
  PrefManager._internal();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Save a string
  Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    prefs.setString(key, value);
  }

  // Get a string
  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  // Save an integer
  Future<void> setInt(String key, int value) async {
    final prefs = await _prefs;
    prefs.setInt(key, value);
  }

  // Get an integer
  Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  // Save a boolean
  Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    prefs.setBool(key, value);
  }

  // Get a boolean
  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  // Remove a key
  Future<void> remove(String key) async {
    final prefs = await _prefs;
    prefs.remove(key);
  }

  // Clear all preferences
  Future<void> clear() async {
    final prefs = await _prefs;
    prefs.clear();
  }


  // is_login

  Future<void> setIsLoggedIn(bool value) async {
    final prefs = await _prefs;
    prefs.setBool("is_login", value);
  }

  // Get a boolean
  Future<bool?> getIsLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool("is_login");
  }

  // auth token

  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString('token');
  }

  Future<void> setToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString('token', token);
  }


  // user Name

  Future<String?> getUserName() async {
    final prefs = await _prefs;
    return prefs.getString('user_name');
  }

  Future<void> setUserName(String userName) async {
    final prefs = await _prefs;
    await prefs.setString('user_name', userName);
  }



  // user email

  Future<String?> getUserEmail() async {
    final prefs = await _prefs;
    return prefs.getString('user_email');
  }

  Future<void> setUserEmail(String userEmail) async {
    final prefs = await _prefs;
    await prefs.setString('user_email', userEmail);
  }


  // user phone

  Future<String?> getUserPhone() async {
    final prefs = await _prefs;
    return prefs.getString('user_phone');
  }

  Future<void> setUserPhone(String userPhone) async {
    final prefs = await _prefs;
    await prefs.setString('user_phone', userPhone);
  }


  // user role

  Future<String?> getUserRole() async {
    final prefs = await _prefs;
    return prefs.getString('user_role');
  }

  Future<void> setUserRole(String userRole) async {
    final prefs = await _prefs;
    await prefs.setString('user_role', userRole);
  }


  // user active inactive

  Future<String?> getUserStatus() async {
    final prefs = await _prefs;
    return prefs.getString('user_status');
  }

  Future<void> setUserStatus(String userStatus) async {
    final prefs = await _prefs;
    await prefs.setString('user_status', userStatus);
  }

  // machine module

  Future<String?> getMachineModule() async {
    final prefs = await _prefs;
    return prefs.getString('machine_module');
  }

  Future<void> setMachineModule(String machineModule) async {
    final prefs = await _prefs;
    await prefs.setString('machine_module', machineModule);
  }



  // supplyChain module

  Future<String?> getSupplyChainModule() async {
    final prefs = await _prefs;
    return prefs.getString('supply_chain_module');
  }

  Future<void> setSupplyChainModule(String machineModule) async {
    final prefs = await _prefs;
    await prefs.setString('supply_chain_module', machineModule);
  }



  // acknowledge_module

  Future<String?> getAcknowledgeModuleModule() async {
    final prefs = await _prefs;
    return prefs.getString('acknowledge_module');
  }

  Future<void> setAcknowledgeModuleModule(String machineModule) async {
    final prefs = await _prefs;
    await prefs.setString('acknowledge_module', machineModule);
  }




  // toner_request_module

  Future<String?> getTonerRequestModule() async {
    final prefs = await _prefs;
    return prefs.getString('toner_request_module');
  }

  Future<void> setTonerRequestModule(String machineModule) async {
    final prefs = await _prefs;
    await prefs.setString('toner_request_module', machineModule);
  }



    // dispatch_module

    Future<String?> getDispatchModule() async {
      final prefs = await _prefs;
      return prefs.getString('dispatch_module');
    }

    Future<void> setDispatchModule(String machineModule) async {
      final prefs = await _prefs;
      await prefs.setString('dispatch_module', machineModule);
    }


    // receive_module

    Future<String?> getReceiveModule() async {
      final prefs = await _prefs;
      return prefs.getString('receive_module');
    }

    Future<void> setReceiveModule(String machineModule) async {
      final prefs = await _prefs;
      await prefs.setString('receive_module', machineModule);
    }





  // user module

  Future<String?> getUserModule() async {
    final prefs = await _prefs;
    return prefs.getString('user_module');
  }

  Future<void> setUserModule(String userModule) async {
    final prefs = await _prefs;
    await prefs.setString('user_module', userModule);
  }


  // client module

  Future<String?> getClientModule() async {
    final prefs = await _prefs;
    return prefs.getString('client_module');
  }

  Future<void> setClientModule(String clientModule) async {
    final prefs = await _prefs;
    await prefs.setString('client_module', clientModule);
  }


}