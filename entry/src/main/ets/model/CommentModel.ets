/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Comment item model
 * Represents a single comment with content and metadata
 */
export class CommentItem {
  // Unique identifier
  id: string;
  
  // Comment content
  content: string;
  
  // Timestamp when the comment was created (milliseconds)
  createdAt: number;
  
  // User name (optional, default to "匿名用户")
  userName: string;
  
  constructor(
    content: string,
    userName: string = '匿名用户'
  ) {
    this.id = `comment_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.content = content;
    this.createdAt = Date.now();
    this.userName = userName;
  }
  
  /**
   * Get formatted time string (e.g., "14:30:25")
   */
  getFormattedTime(): string {
    const date = new Date(this.createdAt);
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    const seconds = date.getSeconds().toString().padStart(2, '0');
    return `${hours}:${minutes}:${seconds}`;
  }
  
  /**
   * Get formatted date time string (e.g., "2026-05-20 14:30:25")
   */
  getFormattedDateTime(): string {
    const date = new Date(this.createdAt);
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const time = this.getFormattedTime();
    return `${year}-${month}-${day} ${time}`;
  }
}
