//! Provides a shared pool of items that can be reused.
//! Each item has a 'make' function that is used to create new items
//! and a 'reset' function that is used to reset items when they are returned to the pool.

use std::cell::RefCell;

/// A pool of items that can be reused.
pub struct Pool<T> {
    free: RefCell<Vec<T>>,
    make: Box<dyn Fn() -> T>,
    reset: Box<dyn Fn(&mut T)>,
}

impl<T> Pool<T> {
    /// Create a new pool.
    ///
    /// The pool will use the given function to create new items
    /// when the pool doesn't have a free item to take.
    ///
    /// When an item is returned to the pool,
    /// it will be reset using the given function.
    pub fn new(make: impl Fn() -> T + 'static, reset: impl Fn(&mut T) + 'static) -> Self {
        Self {
            free: RefCell::new(Vec::new()),
            make: Box::new(make),
            reset: Box::new(reset),
        }
    }

    /// Get an item from the pool.
    ///
    /// If the pool has a free item, it will be returned.
    /// Otherwise, a new item will be created using the function
    /// given to `new`.
    pub fn get(&self) -> Item<T> {
        let item = self
            .free
            .borrow_mut()
            .pop()
            .unwrap_or_else(|| (self.make)());

        Item {
            item: Some(item),
            pool: self,
        }
    }
}

/// Wraps an item from a pool.
///
/// Provides access via mutable and immutable references.
/// When the item is dropped, it will be returned to the pool.
pub struct Item<'a, T> {
    item: Option<T>,
    pool: &'a Pool<T>,
}

impl<'a, T> Drop for Item<'a, T> {
    fn drop(&mut self) {
        if let Some(mut item) = self.item.take() {
            (self.pool.reset)(&mut item);
            self.pool.free.borrow_mut().push(item);
        }
    }
}

impl<'a, T> AsRef<T> for Item<'a, T> {
    fn as_ref(&self) -> &T {
        self.item.as_ref().unwrap()
    }
}

impl<'a, T> std::ops::Deref for Item<'a, T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        self.item.as_ref().unwrap()
    }
}

impl<'a, T> std::ops::DerefMut for Item<'a, T> {
    fn deref_mut(&mut self) -> &mut Self::Target {
        self.item.as_mut().unwrap()
    }
}

impl<'a, T> AsMut<T> for Item<'a, T> {
    fn as_mut(&mut self) -> &mut T {
        self.item.as_mut().unwrap()
    }
}
