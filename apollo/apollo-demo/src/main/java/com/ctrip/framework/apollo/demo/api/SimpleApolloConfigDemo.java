package com.ctrip.framework.apollo.demo.api;

import com.google.common.base.Charsets;

import com.ctrip.framework.apollo.Config;
import com.ctrip.framework.apollo.ConfigChangeListener;
import com.ctrip.framework.apollo.ConfigService;
import com.ctrip.framework.apollo.core.utils.StringUtils;
import com.ctrip.framework.apollo.model.ConfigChange;
import com.ctrip.framework.apollo.model.ConfigChangeEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Properties;
import java.util.Set;

/**
 * @author Jason Song(song_s@ctrip.com)
 */
public class SimpleApolloConfigDemo {
  private static final Logger logger = LoggerFactory.getLogger(SimpleApolloConfigDemo.class);
  private String DEFAULT_VALUE = "undefined";
  private Config config;

  public SimpleApolloConfigDemo() {
    ConfigChangeListener changeListener = new ConfigChangeListener() {
      @Override
      public void onChange(ConfigChangeEvent changeEvent) {
        logger.info("Changes for namespace {}", changeEvent.getNamespace());
        for (String key : changeEvent.changedKeys()) {
          ConfigChange change = changeEvent.getChange(key);
          logger.info("Change - key: {}, oldValue: {}, newValue: {}, changeType: {}",
              change.getPropertyName(), change.getOldValue(), change.getNewValue(),
              change.getChangeType());
        }
      }
    };
    config = ConfigService.getAppConfig();
    config.addChangeListener(changeListener);
  }

  private String getConfig(String key) {
    String result = config.getProperty(key, DEFAULT_VALUE);
    logger.info(String.format("Loading key : %s with value: %s", key, result));
    return result;
  }
  
  private void getAllConfig() throws FileNotFoundException, IOException {
      String appId = System.getProperty("app.id");
      if(StringUtils.isBlank(appId)) {
          throw new RuntimeException("未指定appId");
      }
      Set<String> propertyNames = config.getPropertyNames();
      Properties properties = new Properties();
      for(String propertyName : propertyNames) {
          String result = config.getProperty(propertyName, DEFAULT_VALUE);
          properties.put(propertyName, result);
      }
      properties.store(new FileOutputStream(getPath() + "/" + appId + ".properties"), appId);
    }

  public static void main(String[] args) throws IOException {
      SimpleApolloConfigDemo apolloConfigDemo = new SimpleApolloConfigDemo();
      System.out.println(
        "Apollo Config Demo. Please input key to get the value. Input quit to exit.");
      while (true) {
      System.out.print("> ");
      String input = new BufferedReader(new InputStreamReader(System.in, Charsets.UTF_8)).readLine();
      if (input == null || input.length() == 0) {
        continue;
      }
      input = input.trim();
      if (input.equalsIgnoreCase("quit")) {
        System.exit(0);
      }
      apolloConfigDemo.getConfig(input);
      }
      // apolloConfigDemo.getAllConfig();
  }
  
  
  private String getPath() {
      String path = this.getClass().getProtectionDomain().getCodeSource().getLocation().getPath();
      if(System.getProperty("os.name").contains("dows")) {
          path = path.substring(1, path.length());
      }
      if(path.contains("jar")) {
          path = path.substring(0, path.lastIndexOf("."));
          return path.substring(0, path.lastIndexOf("/"));
      }
      return path.replace("target/classes/", "");
  }

}
